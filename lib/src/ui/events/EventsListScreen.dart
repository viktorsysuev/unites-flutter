import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:unites_flutter/src/blocs/EventsBloc.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/models/EventWithMembers.dart';
import 'package:unites_flutter/src/models/EventWithParticipants.dart';
import 'package:unites_flutter/src/resources/EventRepository.dart';
import 'package:unites_flutter/src/ui/events/CreateEventScreen.dart';
import 'package:unites_flutter/src/ui/events/EventInfoScreen.dart';
import 'package:unites_flutter/src/ui/profile/EditProfileScreen.dart';
import 'package:unites_flutter/src/ui/widgets/LittleWidgetsCollection.dart';

class EventsListScreen extends StatefulWidget {
  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  final eventBloc = EventsBloc();
  DateFormat dateFormat = DateFormat("dd MMMM yyyy");

  @override
  void initState() {
    super.initState();
    eventBloc.addEventsListener();
    eventBloc.getMyEventsWithParticipants();
    eventBloc.getEvents();
  }

  @override
  void dispose() {
    eventBloc.dispose();
    super.dispose();
  }

  Widget _buildEventsScroller() {
    return Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: StreamBuilder<List<EventWithParticipants>>(
            stream: eventBloc.myEventsWithParticipants,
            builder: (BuildContext context,
                AsyncSnapshot<List<EventWithParticipants>> snapshot) {
              Widget child;
              if (snapshot.hasData) {
                child = Column(children: [
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Мои мероприятия',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ))),
                  SizedBox.fromSize(
                      size: Size.fromHeight(160.0),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var event = snapshot.data[index];
                            return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventInfoScreen(
                                            eventId: event.eventModel.id))),
                                child: Container(
                                    width: 240,
                                    child: Card(
                                        color: Colors.black,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      Colors.indigo,
                                                      Colors.blueAccent
                                                    ])),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12.0,
                                                                top: 12.0,
                                                                right: 8),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: <Widget>[
                                                            Text(
                                                              '${event.eventModel.name}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16.0,
                                                              ),
                                                            ),
                                                            Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            5)),
                                                            Text(
                                                              '${event.eventModel.description}',
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white70),
                                                            ),
                                                            Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            5)),
                                                            Text(
                                                              '${dateFormat.format(event.eventModel.start)}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white70),
//                                          ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(left: 12.0, bottom: 14.0),
                                                          child: Stack(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 15,
                                                                backgroundColor:
                                                                Colors.white,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 14.5,
                                                                  backgroundColor:
                                                                      EditProfileScreen.colorById(event
                                                                          .participants[
                                                                              0]
                                                                          .userId),
                                                                  child:
                                                                      ClipOval(
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          300,
                                                                      height:
                                                                          300,
                                                                      child: event.participants[0].avatar !=
                                                                              null
                                                                          ? Image
                                                                              .network(
                                                                              event.participants[0].avatar,
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                          : Center(
                                                                              child: Text('${event.participants[0].firstName[0]}${event.participants[0]..lastName[0]}', style: TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.center)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              event.participants
                                                                          .length >
                                                                      1
                                                                  ? Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              22.0),
                                                                      child: CircleAvatar(
                                                                          radius: 15,
                                                                          backgroundColor: Colors.white,
                                                                          child: CircleAvatar(
                                                                            radius:
                                                                                14.5,
                                                                            backgroundColor:
                                                                                EditProfileScreen.colorById(event.participants[1].userId),
                                                                            child:
                                                                                ClipOval(
                                                                              child: SizedBox(
                                                                                width: 300,
                                                                                height: 300,
                                                                                child: event.participants[1].avatar != null
                                                                                    ? Image.network(
                                                                                        event.participants[1].avatar,
                                                                                        fit: BoxFit.cover,
                                                                                      )
                                                                                    : Center(child: Text('${event.participants[1].firstName[0]}${event.participants[1].lastName[0]}', style: TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.center)),
                                                                              ),
                                                                            ),
                                                                          )))
                                                                  : Container(),
                                                              event.participants
                                                                  .length > 2
                                                                  ? Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left:
                                                                      44.0),
                                                                      child: CircleAvatar(
                                                                        radius: 14.5,
                                                                        backgroundColor: Colors.white,
                                                                        child: Text('+${event.participants.length - 2} ', style: TextStyle(fontSize: 11.0),)
                                                                      ))
                                                                  : Container()
                                                            ],
                                                          )))

//
                                                ])))));
                          }))
                ]);
              } else {
                child = Column();
              }
              return child;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateEventScreen()));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.lightBlue,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: StreamBuilder<List<EventModel>>(
            stream: eventBloc.events,
            builder: (BuildContext context,
                AsyncSnapshot<List<EventModel>> snapshot) {
              Widget child;
              var bufferWidgets = <Widget>[];
              if (snapshot.hasData) {
                bufferWidgets.add(_buildEventsScroller());
                bufferWidgets.add(Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Все мероприятия',
                      style: TextStyle(fontSize: 16),
                    )));
                snapshot.data.forEach((element) {
                  bufferWidgets.add(Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Card(
                          child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EventInfoScreen(eventId: element.id)));
                        },
                        title: Text('${element.name}'),
                        subtitle: Text('${element.company}'),
                      ))));
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
