import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/ui/bloc/user_bloc.dart';
import 'package:unites_flutter/domain/models/user_model.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';
import 'package:unites_flutter/ui/auth/input_phone_number_screen.dart';
import 'package:unites_flutter/ui/profile/edit_profile_screen.dart';
import 'package:unites_flutter/ui/util/theme_controller.dart';

class ProfileMainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileMainScreenState();
  }
}

class ProfileMainScreenState extends State<ProfileMainScreen> {
  var userRepository = getIt<UserRepositoryImpl>();
  final userBloc = getIt<UsersBloc>();

  @override
  void didChangeDependencies() {
    userBloc.fetchCurrentUser();
    super.didChangeDependencies();
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
                  userRepository.logout();
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
            return buildInfo(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildInfo(AsyncSnapshot<UserModel> snapshot, BuildContext context) {
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
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
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
          Row(
            children: [
              Container(padding: EdgeInsets.only(left: 12.0)),
              Text('Ночной режим', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              Container(padding: EdgeInsets.only(left: 8.0)),
              Switch(
                  value: ThemeController.of(context).currentTheme == 'dark',
                  onChanged: (bool newValue) {
                    setState(() {
                      if(newValue == true){
                        ThemeController.of(context).setTheme('dark');
                      } else{
                        ThemeController.of(context).setTheme('light');
                      }
                    });
                  })
            ],
          )
        ]),
      ),
    );
  }
}
