import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unites_flutter/src/blocs/story_bloc.dart';
import 'package:unites_flutter/src/models/story_model.dart';
import 'package:unites_flutter/src/models/user_model.dart';
import 'package:video_player/video_player.dart';

class StoryScreen extends StatefulWidget {
  UserModel user;

  StoryScreen({@required this.user});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  var storyBloc = StoryBloc();
  PageController pageController;
  VideoPlayerController videoPlayerController;
  AnimationController animController;

  var stories = <StoryModel>[];

  int currentIndex = 0;

  @override
  void initState() {
    storyBloc.fetchStories(widget.user.userId);
    pageController = PageController();
    animController = AnimationController(vsync: this);

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
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            currentIndex = 0;
            loadStory(story: stories[currentIndex]);
          }
        });
        if (videoPlayerController != null) {
          videoPlayerController.play();
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    animController.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<StoryModel>>(
            stream: storyBloc.getStories,
            builder: (BuildContext context,
                AsyncSnapshot<List<StoryModel>> snapshot) {
              Widget child;
              if (snapshot.hasData) {
                stories = snapshot.data;
                child = GestureDetector(
                  onTapDown: (details) =>
                      _onTapDown(details, stories[currentIndex]),
                  child: Stack(children: [
                    PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        controller: pageController,
                        itemBuilder: (context, i) {
                          final story = snapshot.data[i];
                          switch (story.mediaType) {
                            case MediaType.IMAGE:
                              return CachedNetworkImage(
                                imageUrl: story.url,
                                fit: BoxFit.cover,
                              );
                            case MediaType.VIDEO:
                              if (videoPlayerController != null &&
                                  videoPlayerController.value.initialized) {
                                return FittedBox(
                                  fit: BoxFit.contain,
                                  child: SizedBox(
                                    width:
                                        videoPlayerController.value.size.width,
                                    height:
                                        videoPlayerController.value.size.height,
                                    child: VideoPlayer(videoPlayerController),
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
                            children: snapshot.data
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
                            child: UserInfo(user: widget.user),
                          ),
                        ]))
                  ]),
                );
              } else {
                child = Container();
              }

              return child;
            }));
  }

  void _onTapDown(TapDownDetails details, StoryModel story) {
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
          currentIndex = 0;
          loadStory(story: stories[currentIndex]);
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
    switch (story.mediaType) {
      case MediaType.IMAGE:
        animController.duration = Duration(seconds: 5);
        animController.forward();
        break;
      case MediaType.VIDEO:
        videoPlayerController = null;
        videoPlayerController?.dispose();
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

  const UserInfo({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
