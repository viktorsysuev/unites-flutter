import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/ui/bloc/story_bloc.dart';
import 'package:unites_flutter/ui/bloc/user_bloc.dart';
import 'package:unites_flutter/domain/models/user_model.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';
import 'package:unites_flutter/ui/profile/edit_profile_screen.dart';
import 'package:unites_flutter/ui/profile/userInfo_screen.dart';
import 'package:unites_flutter/ui/stories/create_story_screen.dart';
import 'package:unites_flutter/ui/stories/story_screen.dart';
import 'package:unites_flutter/ui/widgets/little_widgets_collection.dart';

class ContactsListScreen extends StatefulWidget {
  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  final userBloc = getIt<UsersBloc>();
  final storyBloc = StoryBloc();

  var userRepository = getIt<UserRepositoryImpl>();
  var usersToSend = <UserModel>[];

  @override
  void didChangeDependencies() {
    userBloc.fetchContacts();
    userBloc.fetchContactsWithStory();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    userBloc.dispose();
    super.dispose();
  }

  Widget buildStoriesList(List<UserModel> users) {
    userBloc.fetchContactsWithStory();
    return SizedBox.fromSize(
        size: Size.fromHeight(110.0),
        child: StreamBuilder<List<UserModel>>(
            stream: userBloc.getContactsWithStory,
            builder: (BuildContext context,
                AsyncSnapshot<List<UserModel>> snapshot) {
              Widget child;
              if (snapshot.hasData) {
                var users = List.of(snapshot.data!);
                if (snapshot.data!.contains(userRepository.currentUser)) {
                  users.remove(userRepository.currentUser);
                }
                child = ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    itemCount: users.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      var user = index == 0
                          ? userRepository.currentUser
                          : users[index - 1];
                      usersToSend.add(user);
                      return index == 0 && !snapshot.data!.contains(user)
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 8.0, right: 10.0),
                              child: Stack(children: <Widget>[
                                Container(
                                    width: 90.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1.0, vertical: 1.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateStoryScreen()));
                                        },
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 26,
                                              backgroundColor:
                                                  EditProfileScreen.colorById(
                                                      user.userId),
                                              child: ClipOval(
                                                child: SizedBox(
                                                  width: 300,
                                                  height: 300,
                                                  child: user.avatar != null
                                                      ? Image.network(
                                                          user.avatar!,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Center(
                                                          child: Text(
                                                              '${user.firstName[0]}${user.lastName[0]}',
                                                              style: TextStyle(
                                                                  fontSize: 24,
                                                                  color: Colors
                                                                      .white),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Text('Ваша история',
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 13.0),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            )
                                          ],
                                        ))),
                                Positioned(
                                    right: 15,
                                    bottom: 32,
                                    child: SvgPicture.asset(
                                      'assets/images/add.svg',
                                      width: 20,
                                      height: 20,
                                    )),
                              ]),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, right: 10.0),
                              child: Container(
                                  width: 60.0,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 1.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StoryScreen(
                                                        user: user,
                                                        users: usersToSend)));
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      Colors.pink,
                                                      Colors.yellow
                                                    ])),
                                            child: CircleAvatar(
                                              radius: 29,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: CircleAvatar(
                                                radius: 26,
                                                backgroundColor:
                                                    EditProfileScreen.colorById(
                                                        user.userId),
                                                child: ClipOval(
                                                  child: SizedBox(
                                                    width: 300,
                                                    height: 300,
                                                    child: user.avatar != null
                                                        ? Image.network(
                                                            user.avatar!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Center(
                                                            child: Text(
                                                                '${user.firstName[0]}${user.lastName[0]}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .white),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text('${user.firstName}',
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 13.0),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ))),
                            );
                    });
              } else {
                child = Container();
              }
              return child;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Контакты'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: StreamBuilder<List<UserModel>>(
            stream: userBloc.getContacts,
            builder: (BuildContext context,
                AsyncSnapshot<List<UserModel>> snapshot) {
              Widget child;
              var bufferWidgets = <Widget>[];
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                bufferWidgets.add(buildStoriesList(snapshot.data!));
                snapshot.data!.forEach((element) {
                  bufferWidgets.add(GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserInfoScreen(userId: element.userId))),
                      child: Card(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                            Container(
                                margin: EdgeInsets.all(8),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: EditProfileScreen.colorById(
                                      element.userId),
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: element.avatar != null
                                          ? Image.network(element.avatar!,
                                              fit: BoxFit.cover)
                                          : Center(
                                              child: Text(
                                                  '${element.firstName[0]}${element.lastName[0]}',
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center)),
                                    ),
                                  ),
                                )),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      '${element.firstName} ${element.lastName}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      '${element.company}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]))));
                });
                child = Column(
                  children: bufferWidgets,
                  crossAxisAlignment: CrossAxisAlignment.start,
                );
              } else if (snapshot.hasError) {
                child = Center(child: WidgetErrorLoad());
              } else {
                child = Column(children: [
                  Container(
                      margin: EdgeInsets.only(top: 100),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/broke.svg',
                        width: 100,
                        height: 160,
                      )),
                  Container(padding: EdgeInsets.only(top: 16)),
                  Text('В контактах пока никого нет',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center)
                ]);
                ;
              }
              return child;
            },
          ),
        ));
    ;
  }
}
