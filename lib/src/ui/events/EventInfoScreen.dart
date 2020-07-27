import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unites_flutter/src/blocs/EventsBloc.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/models/EventWithParticipants.dart';
import 'package:unites_flutter/src/ui/events/ParticipantsListScreen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Мероприятие'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
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
                    Center(
                      child: Text('${snapshot.data.eventModel.description}',
                          style: TextStyle(fontSize: 16.0)),
                    ),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Center(
                      child: Text('${snapshot.data.eventModel.company}',
                          style: TextStyle(fontSize: 16.0)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
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
                                      'Участников ${snapshot.data.participants.length}',
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
                    Container(margin: EdgeInsets.only(top: 20.0, bottom: 20.0)),
                    Center(
                      child: RaisedButton(
                        color: Colors.lightBlue,
                        child: Text('$buttonText'),
                        onPressed: () {
                          eventBloc
                              .isMember(widget.eventId)
                              .then((isParticipant) => {
                                    if (isParticipant)
                                      {
                                        print("left"),
                                        eventBloc.leftEvent(widget.eventId),
                                        eventBloc.getEventWithParticipants(widget.eventId),
                                      }
                                    else
                                      {
                                        print("join"),
                                        eventBloc.joinEvent(widget.eventId),
                                        eventBloc.getEventWithParticipants(widget.eventId),
                                      }
                                  });
                          setState(() {
                            if(buttonText == 'Вступить'){
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
