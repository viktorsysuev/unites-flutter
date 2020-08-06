import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unites_flutter/src/blocs/EventsBloc.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/models/EventWithParticipants.dart';
import 'package:unites_flutter/src/models/ParticipantsModel.dart';
import 'package:unites_flutter/src/ui/events/ParticipantsListScreen.dart';
import 'package:unites_flutter/src/ui/profile/EditProfileScreen.dart';
import 'package:unites_flutter/src/ui/profile/UserInfoScreen.dart';
import 'package:unites_flutter/src/ui/widgets/LittleWidgetsCollection.dart';

class EventInfoScreen extends StatefulWidget {
  String eventId;

  EventInfoScreen({@required this.eventId});

  @override
  _EventInfoScreenState createState() => _EventInfoScreenState();
}

class _EventInfoScreenState extends State<EventInfoScreen> {
  final eventBloc = EventsBloc();
  final formatter = DateFormat('yyyy-MM-dd hh:mm');
  var buttonText = '';

  @override
  void initState() {
    eventBloc.addParticipantsListener();
    eventBloc.isMember(widget.eventId).then((isParticipant) => {
          if (isParticipant)
            {buttonText = 'Покинуть мероприятие'}
          else
            {buttonText = 'Вступить'}
        });
    eventBloc.getEventWithParticipants(widget.eventId);
    super.initState();
  }

  @override
  void dispose() {
    eventBloc.dispose();
    super.dispose();
  }

  Widget _buildParticipantsScroller(List<ParticipantsModel> participants) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: SizedBox.fromSize(
        size: Size.fromHeight(75.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemCount: participants.length,
          itemBuilder: (BuildContext context, int index) {
            var user = participants[index];
            return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserInfoScreen(userId: user.userId)));
                    },
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: EditProfileScreen.colorById(user.userId),
                      child: ClipOval(
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: user.avatar != null
                              ? Image.network(
                                  user.avatar,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Text(
                                      '${user.firstName[0]}${user.lastName[0]}',
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.white),
                                      textAlign: TextAlign.center)),
                        ),
                      ),
                    )));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Мероприятие'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: StreamBuilder<EventWithParticipants>(
            stream: eventBloc.eventWithParticipants,
            builder: (BuildContext context,
                AsyncSnapshot<EventWithParticipants> snapshot) {
              Widget child;

              if (snapshot.hasData) {
                child = SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Container(margin: EdgeInsets.only(top: 16.0, bottom: 8.0)),
                    Center(
                      child: Text('${snapshot.data.eventModel.name}',
                          style: TextStyle(fontSize: 22.0)),
                    ),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text('${snapshot.data.eventModel.description}',
                              style: TextStyle(fontSize: 16.0)),
                        )),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Center(
                      child: Text('${snapshot.data.eventModel.company}',
                          style: TextStyle(fontSize: 16.0)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text('Адрес:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text('${snapshot.data.eventModel.address}',
                                style: TextStyle(fontSize: 16.0)),
                            Container(margin: EdgeInsets.only(top: 16.0)),
                            Text('Начало:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text(
                                '${formatter.format(snapshot.data.eventModel.start)}',
                                style: TextStyle(fontSize: 16.0)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text('Конец:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text(
                                '${formatter.format(snapshot.data.eventModel.end)}',
                                style: TextStyle(fontSize: 16.0)),
                            Container(margin: EdgeInsets.only(top: 16.0)),
                            RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                  text:
                                      'Участники (${snapshot.data.participants.length}):',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ParticipantsListScreen(
                                                      eventId: snapshot.data
                                                          .eventModel.id)));
                                    }),
                            ),
                          ]),
                    ),
                    _buildParticipantsScroller(snapshot.data.participants),
                    Container(margin: EdgeInsets.only(top: 20.0, bottom: 20.0)),
                    Center(
                      child: OutlineButton(
                        child: Text('$buttonText'),
                        onPressed: () {
                          eventBloc
                              .isMember(widget.eventId)
                              .then((isParticipant) => {
                                    if (isParticipant)
                                      {
                                        print("left"),
                                        eventBloc.leftEvent(widget.eventId),
                                        eventBloc.getEventWithParticipants(
                                            widget.eventId),
                                      }
                                    else
                                      {
                                        print("join"),
                                        eventBloc.joinEvent(widget.eventId),
                                        eventBloc.getEventWithParticipants(
                                            widget.eventId),
                                      }
                                  });
                          setState(() {
                            if (buttonText == 'Вступить') {
                              buttonText = 'Покинуть мероприятие';
                            } else {
                              buttonText = 'Вступить';
                            }
                          });
                        },
                      ),
                    ),
                  ]),
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
