import 'package:flutter/material.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/ui/app.dart';
import 'package:unites_flutter/ui/bloc/event_bloc.dart';
import 'package:unites_flutter/domain/models/user_model.dart';
import 'package:unites_flutter/ui/profile/edit_profile_screen.dart';
import 'package:unites_flutter/ui/profile/userInfo_screen.dart';
import 'package:unites_flutter/ui/widgets/little_widgets_collection.dart';

class ParticipantsListScreen extends StatefulWidget {
  String eventId;

  ParticipantsListScreen({@required this.eventId});

  @override
  _ParticipantsListScreenState createState() => _ParticipantsListScreenState();
}

class _ParticipantsListScreenState extends State<ParticipantsListScreen> {
  final eventBloc = getIt<EventsBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    eventBloc.getEventParticipants(widget.eventId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
//    eventBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Участники'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: StreamBuilder<List<UserModel>>(
            stream: eventBloc.participants,
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
