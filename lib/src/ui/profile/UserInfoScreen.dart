import 'package:flutter/material.dart';
import 'package:unites_flutter/src/blocs/UsersBloc.dart';
import 'package:unites_flutter/src/models/UserModel.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';
import 'package:unites_flutter/src/ui/chats/PrivateChatScreen.dart';

import 'EditProfileScreen.dart';

class UserInfoScreen extends StatefulWidget {
  String userId;

  UserInfoScreen({@required this.userId});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final userRepository = UserRepository();
  final userBloc = UsersBloc();

  @override
  void initState() {
    super.initState();
    userBloc.getUserById(widget.userId);
  }

  @override
  void dispose() {
    userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Пользователь'),
      ),
      body: StreamBuilder(
        stream: userBloc.getUser,
        builder: (context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            return buildInfo(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildInfo(AsyncSnapshot<UserModel> snapshot) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(margin: EdgeInsets.only(top: 16.0, bottom: 8.0)),
          CircleAvatar(
            radius: 84,
            backgroundColor: EditProfileScreen.colorById(snapshot.data.userId),
            child: ClipOval(
              child: SizedBox(
                width: 300,
                height: 300,
                child: snapshot.data.avatar != null
                    ? Image.network(
                        snapshot.data.avatar,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                            '${snapshot.data.firstName[0]}${snapshot.data.lastName[0]}',
                            style: TextStyle(fontSize: 44, color: Colors.white),
                            textAlign: TextAlign.center)),
              ),
            ),
          ),
          Container(margin: EdgeInsets.only(top: 16.0, bottom: 8.0)),
          Center(
            child: Text('${snapshot.data.firstName} ${snapshot.data.lastName}',
                style: TextStyle(fontSize: 22.0)),
          ),
          Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('${snapshot.data.aboutMe}',
                    style: TextStyle(fontSize: 16.0)),
              )),
          Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
          Center(
            child: Text('${snapshot.data.company}',
                style: TextStyle(fontSize: 16.0)),
          ),
          Padding(
            padding: EdgeInsets.all(24.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Container(margin: EdgeInsets.only(top: 8.0)),
              Text('Я ищу (каких людей/услуги/товары):',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              Container(margin: EdgeInsets.only(top: 8.0)),
              Text('${snapshot.data.interests}',
                  style: TextStyle(fontSize: 16.0)),
              Container(margin: EdgeInsets.only(top: 16.0)),
              Text('Чем могу быть полезен:',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              Container(margin: EdgeInsets.only(top: 8.0)),
              Text('${snapshot.data.useful}', style: TextStyle(fontSize: 16.0)),
              Container(margin: EdgeInsets.only(top: 16.0)),
              Text('Телефон: ${snapshot.data.phone}',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ]),
          ),
          Container(margin: EdgeInsets.only(top: 10.0, bottom: 10.0)),
          Center(
            child: OutlineButton(
              color: Colors.lightBlue,
              child: Text('Написать сообщение'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PrivateChatScreen(userId: snapshot.data.userId)));
              },
            ),
          ),
        ]),
      ),
    );
  }
}
