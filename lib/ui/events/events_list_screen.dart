import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/ui/bloc/event_bloc.dart';
import 'package:unites_flutter/domain/models/event_model.dart';
import 'package:unites_flutter/domain/models/event_with_participants.dart';
import 'package:unites_flutter/ui/events/create_event_screen.dart';
import 'package:unites_flutter/ui/events/event_info_screen.dart';
import 'package:unites_flutter/ui/profile/edit_profile_screen.dart';
import 'package:unites_flutter/ui/widgets/little_widgets_collection.dart';



class EventsListScreen extends StatefulWidget {
  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  DateFormat dateFormat = DateFormat("dd MMMM yyyy");
  final eventBloc = getIt<EventsBloc>();



  @override
  void didChangeDependencies() {
    eventBloc.addEventsListener();
    eventBloc.getMyEventsWithParticipants();
    eventBloc.getEvents();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
//    eventBloc.dispose();
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
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                child = Column(children: [
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Мои мероприятия',
                            style: TextStyle(fontSize: 16),
                          ))),
                  SizedBox.fromSize(
                      size: Size.fromHeight(160.0),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            var event = snapshot.data![index];
                            return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventInfoScreen(
                                            eventId: event.eventModel!.id))),
                                child: Container(
                                    width: 240,
                                    child: Card(
                                        color: Colors.black,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0)),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      Colors.indigo,
                                                      Colors.blueAccent
                                                    ])),
                                            child: Column(
                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Align(
                                                    alignment: Alignment.topLeft,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12.0,
                                                                top: 9.0,
                                                                right: 8),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: <Widget>[
                                                            Text(
                                                              '${event.eventModel?.name}',
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 16.0,
                                                              ),
                                                            ),
                                                            Container(padding: EdgeInsets.all(4)),
                                                            Text(
                                                              '${event.eventModel?.description}',
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(color: Colors.white70),
                                                            ),
                                                            Container(
                                                                padding: EdgeInsets.all(4)),
                                                            Text(
                                                              '${dateFormat.format(event.eventModel!.start!)}',
                                                              style: TextStyle(color: Colors
                                                                      .white70),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ),
                                                  event.participants!.isNotEmpty ? Align(
                                                      alignment: Alignment.bottomLeft,
                                                      child: Padding(padding: EdgeInsets.only(left: 12.0, bottom: 8.0),
                                                          child: Stack(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 15,
                                                                backgroundColor:
                                                                Colors.white,
                                                                child: CircleAvatar(
                                                                  radius: 14.5,
                                                                  backgroundColor:
                                                                      EditProfileScreen.colorById(
                                                                          event.participants![0].userId),
                                                                  child: ClipOval(
                                                                    child: SizedBox(
                                                                      width: 300,
                                                                      height: 300,
                                                                      child: event.participants![0].avatar != null
                                                                          ? Image
                                                                              .network(
                                                                              event.participants![0].avatar!,
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                          : Center(
                                                                              child: Text('${event.participants![0].firstName[0]}${event.participants![0]..lastName[0]}', style: TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.center)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              event.participants!.length > 1
                                                                  ? Padding(
                                                                      padding: EdgeInsets.only(  left: 22.0),
                                                                      child: CircleAvatar(
                                                                          radius: 15,
                                                                          backgroundColor: Colors.white,
                                                                          child: CircleAvatar(
                                                                            radius: 14.5,
                                                                            backgroundColor: EditProfileScreen.colorById(event.participants![1].userId),
                                                                            child: ClipOval(
                                                                              child: SizedBox(
                                                                                width: 300,
                                                                                height: 300,
                                                                                child: event.participants![1].avatar != null
                                                                                    ? Image.network(
                                                                                        event.participants![1].avatar!,
                                                                                        fit: BoxFit.cover,
                                                                                      )
                                                                                    : Center(child: Text('${event.participants![1].firstName[0]}${event.participants?[1].lastName[0]}', style: TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.center)),
                                                                              ),
                                                                            ),
                                                                          )))
                                                                  : Container(),
                                                              event.participants!.length > 2
                                                                  ? Padding(
                                                                  padding: EdgeInsets.only(left: 44.0),
                                                                      child: CircleAvatar(
                                                                        radius: 14.5,
                                                                        backgroundColor: Colors.white,
                                                                        child: Text('+${event.participants!.length - 2} ', style: TextStyle(fontSize: 11.0),)
                                                                      ))
                                                                  : Container()
                                                            ],
                                                          ))) : Container()

//
                                                ])))));
                          }))
                ]);
              } else {
                eventBloc.getMyEventsWithParticipants();
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
                snapshot.data?.forEach((element) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bufferWidgets,
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
