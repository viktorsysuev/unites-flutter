import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unites_flutter/main.dart';
import 'package:unites_flutter/src/blocs/event_bloc.dart';
import 'package:unites_flutter/src/blocs/user_bloc.dart';
import 'package:unites_flutter/src/models/user_model.dart';
import 'package:unites_flutter/src/ui/profile/edit_profile_screen.dart';
import 'package:unites_flutter/src/ui/profile/userInfo_screen.dart';
import 'package:unites_flutter/src/ui/widgets/little_widgets_collection.dart';

class ContactsListScreen extends StatefulWidget {
  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  final userBloc = getIt<UsersBloc>();


  @override
  void didChangeDependencies() {
    userBloc.fetchContacts();
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
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                snapshot.data.forEach((element) {
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
                                          ? Image.network(element.avatar,
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
                ]);;
              }
              return child;
            },
          ),
        ));
    ;
  }
}
