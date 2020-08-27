import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as Path;
import 'package:unites_flutter/main.dart';
import 'package:unites_flutter/src/blocs/story_bloc.dart';
import 'package:unites_flutter/src/models/story_model.dart';
import 'package:unites_flutter/src/models/user_model.dart';
import 'package:unites_flutter/src/resources/user_repository.dart';
import 'package:unites_flutter/src/ui/stories/create_story_screen.dart';
import 'package:video_player/video_player.dart';

class StoryScreen extends StatefulWidget {
  UserModel user;

  List<UserModel> users;

  StoryScreen({@required this.user, this.users});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  var storyBloc = StoryBloc();
  PageController pageController;
  PageController globalPageController;
  VideoPlayerController videoPlayerController;
  AnimationController animController;

  var stories = <StoryModel>[];
  var allStories = <StoryModel>[];

  int currentIndex = 0;
  int currentGlobalIndex = 0;
  int curPage = 0;
  var currentPageValue = 1.0;

  @override
  void initState() {
    widget.users.reversed;
    currentGlobalIndex = widget.users.indexOf(widget.user);
    storyBloc.fetchStories(widget.user.userId);
    pageController = PageController();
    globalPageController = PageController(initialPage: currentGlobalIndex);
    animController = AnimationController(vsync: this);
    curPage = currentGlobalIndex;

    if (currentGlobalIndex == widget.users.length - 1) {
      currentPageValue = 0;
    }

    storyBloc.getStories.listen((event) {
      loadStory(story: event[0], animateToPage: false);
    });
    animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animController.stop();
        animController.reset();
        setState(() {
          if (currentIndex + 1 < stories.length) {
            currentIndex += 1;
            loadStory(story: stories[currentIndex]);
          } else {
            Navigator.of(context).pop();
          }
        });
        if (videoPlayerController != null) {
          videoPlayerController.play();
        }
      }

      globalPageController.addListener(() {
        if (globalPageController.page == currentGlobalIndex.toDouble()) {
          animController.forward();
          videoPlayerController?.play();
        } else {
          animController.stop();
          videoPlayerController?.pause();
        }
        setState(() {
          currentPageValue = globalPageController.page;
        });
        if (curPage != globalPageController.page.floor()) {
          curPage = globalPageController.page.floor();
          setState(() {
            currentGlobalIndex = globalPageController.page.floor();
            currentIndex = 0;
            stories = allStories
                .where((element) =>
                    element.userId == widget.users[currentGlobalIndex].userId)
                .toList();
//            widget.user = widget.users[currentGlobalIndex];
            loadStory(story: stories[currentIndex], animateToPage: false);
          });
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    animController.removeListener(() {});
    pageController.dispose();
    animController.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Dismissible(
      direction: DismissDirection.vertical,
      key: Key('key'),
      onDismissed: (_) => Navigator.of(context).pop(),
      child: StreamBuilder<List<StoryModel>>(
          stream: storyBloc.getStories,
          builder:
              (BuildContext context, AsyncSnapshot<List<StoryModel>> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              allStories = snapshot.data;
              stories = snapshot.data
                  .where((element) =>
                      element.userId == widget.users[currentGlobalIndex].userId)
                  .toList();
              child = PageView.builder(
                  itemCount: widget.users.length,
                  controller: globalPageController,
                  itemBuilder: (context, userIndex) {
                    var currentUserStories = snapshot.data
                        .where(
                            (e) => e.userId == widget.users[userIndex].userId)
                        .toList();
                    stories = currentUserStories;
                    if (userIndex == currentPageValue.floor()) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..rotateX(currentPageValue - userIndex),
                        child: Container(
                          child: storyWidget(currentUserStories, userIndex),
                        ),
                      );
                    } else if (userIndex == currentPageValue.floor() + 1) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..rotateX(currentPageValue - userIndex),
                        child: Container(
                            child: storyWidget(currentUserStories, userIndex)),
                      );
                    } else {
                      return storyWidget(currentUserStories, userIndex);
                    }
                  });
            } else {
              child = Container();
            }

            return child;
          }),
    ));
  }

  void _onTapUp(TapUpDetails details, List<StoryModel> stories) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (currentIndex - 1 >= 0) {
          currentIndex -= 1;
          loadStory(story: stories[currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (currentIndex + 1 < stories.length) {
          currentIndex += 1;
          loadStory(story: stories[currentIndex]);
        } else {
          if (currentGlobalIndex < widget.users.length - 1) {
            currentIndex = 0;
            currentGlobalIndex += 1;
            stories = allStories
                .where((element) =>
                    element.userId == widget.users[currentGlobalIndex].userId)
                .toList();
            print(
                'currentGlobalIndex $currentGlobalIndex currentIndex $currentIndex');
            globalPageController.animateToPage(currentGlobalIndex,
                duration: Duration(seconds: 1), curve: Curves.ease);
            loadStory(story: stories[currentIndex]);
          } else {
            Navigator.of(context).pop();
          }
        }
      });
    } else {
      if (videoPlayerController.value.isPlaying) {
        videoPlayerController.pause();
        animController.stop();
      } else {
        videoPlayerController.play();
        animController.forward();
      }
    }
  }

  void loadStory({StoryModel story, bool animateToPage = true}) {
    animController.stop();
    animController.reset();
    if (videoPlayerController != null) {
      videoPlayerController.pause();
    }
    switch (story.mediaType) {
      case MediaType.IMAGE:
        animController.duration = Duration(seconds: 5);
        animController.forward();
        break;
      case MediaType.VIDEO:
        videoPlayerController?.dispose();
        videoPlayerController = null;
        videoPlayerController = VideoPlayerController.network(story.url)
          ..initialize().then((_) {
            setState(() {});
            if (videoPlayerController.value.initialized) {
              animController.duration = videoPlayerController.value.duration;
              videoPlayerController.play();
              animController.forward();
            }
          });
        break;
    }
    if (animateToPage) {
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget storyWidget(List<StoryModel> currentUserStories, int userIndex) {
    return GestureDetector(
      onTapUp: (details) => _onTapUp(details, currentUserStories),
      child: Stack(children: [
        PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: currentUserStories.length,
            controller: pageController,
            itemBuilder: (context, i) {
              final story = currentUserStories[i];
              switch (story.mediaType) {
                case MediaType.IMAGE:
                  return CachedNetworkImage(
                    imageUrl: story.url,
                    fit: BoxFit.cover,
                  );
                case MediaType.VIDEO:
                  if (videoPlayerController != null &&
                      videoPlayerController.value.initialized) {
                    return Container(
                      height: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: videoPlayerController.value.size.width,
                          height: videoPlayerController.value.size.height,
                          child: VideoPlayer(videoPlayerController),
                        ),
                      ),
                    );
                  }
              }
              return const SizedBox.shrink();
            }),
        Positioned(
            top: 40.0,
            left: 10.0,
            right: 10.0,
            child: Column(children: <Widget>[
              Row(
                children: currentUserStories
                    .asMap()
                    .map((i, e) {
                      return MapEntry(
                        i,
                        AnimatedBar(
                          animController: animController,
                          position: i,
                          currentIndex: currentIndex,
                        ),
                      );
                    })
                    .values
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 1.5,
                  vertical: 10.0,
                ),
                child: UserInfo(user: widget.users[userIndex]),
              ),
            ]))
      ]),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    Key key,
    @required this.animController,
    @required this.position,
    @required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animController.value,
                            Colors.white,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final UserModel user;

  UserInfo({
    Key key,
    @required this.user,
  }) : super(key: key);

//
  final userRepository = getIt<UserRepository>();
  final storyBloc = StoryBloc();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.grey[300],
              backgroundImage: CachedNetworkImageProvider(
                user.avatar,
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                user.firstName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        userRepository.currentUser.userId == user.userId
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateStoryScreen()));
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 170,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.pinkAccent, Colors.orangeAccent]),
                        shape: BoxShape.rectangle,
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, top: 4.0, bottom: 4.0),
                          child: Icon(Icons.add),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text('Добавить историю',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
