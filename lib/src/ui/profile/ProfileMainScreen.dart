import 'package:flutter/material.dart';
import 'package:unites_flutter/src/blocs/UsersBloc.dart';
import 'package:unites_flutter/src/models/UserModel.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';

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
          Center(
            child: Text('${snapshot.data.firstName} ${snapshot.data.lastName}',
                style: TextStyle(fontSize: 22.0)),
          ),
          Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
          Center(
            child: Text('${snapshot.data.aboutMe}',
                style: TextStyle(fontSize: 16.0)),
          ),
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
              Text('Я ищу (каих людей/услуги/товары):',
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
          Center(
            child: RaisedButton(
              color: Colors.lightBlue,
              child: Text('Выйти'),
              onPressed: () {},
            ),
          ),
        ]),
      ),
    );
  }
}
