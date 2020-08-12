import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:unites_flutter/src/blocs/UsersBloc.dart';
import 'package:unites_flutter/src/models/UserModel.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';
import 'package:unites_flutter/src/ui/auth/InputPhoneNumberScreen.dart';
import 'package:unites_flutter/src/ui/profile/EditProfileScreen.dart';

class ProfileMainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileMainScreenState();
  }
}

class ProfileMainScreenState extends State<ProfileMainScreen> {
  final userRepository = UserRepository();
  final userBloc = UsersBloc();

  @override
  void initState() {
    super.initState();
    userBloc.fetchCurrentUser();
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
        title: Text('Профиль'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()));
                },
                child: Icon(
                  Icons.edit,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  UserRepository().logout();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => InputPhoneNumberScreen()),
                      (Route<dynamic> route) => false);
                },
                child: Icon(
                  Icons.exit_to_app,
                  size: 26.0,
                ),
              )),
        ],
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
            padding: EdgeInsets.all(12.0),
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
            ]),
          ),
          Container(margin: EdgeInsets.only(top: 20.0, bottom: 20.0)),
        ]),
      ),
    );
  }
}
