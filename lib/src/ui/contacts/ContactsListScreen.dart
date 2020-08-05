import 'package:flutter/material.dart';
import 'package:unites_flutter/src/blocs/EventsBloc.dart';
import 'package:unites_flutter/src/blocs/UsersBloc.dart';
import 'package:unites_flutter/src/models/UserModel.dart';
import 'package:unites_flutter/src/ui/profile/EditProfileScreen.dart';
import 'package:unites_flutter/src/ui/profile/UserInfoScreen.dart';
import 'package:unites_flutter/src/ui/widgets/LittleWidgetsCollection.dart';

class ContactsListScreen extends StatefulWidget {
  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  final userBloc = UsersBloc();

  @override
  void initState() {
    userBloc.fetchContacts();
    super.initState();
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
          padding: EdgeInsets.all(10),
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: StreamBuilder<List<UserModel>>(
            stream: userBloc.getContacts,
            builder: (BuildContext context,
                AsyncSnapshot<List<UserModel>> snapshot) {
              Widget child;
              var bufferWidgets = <Widget>[];
              if (snapshot.hasData) {
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
                                        color: Colors.white,
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
                child = Center(child: WidgetDataLoad());
              }
              return child;
            },
          ),
        ));
    ;
  }
}
