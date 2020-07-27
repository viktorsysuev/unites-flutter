import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:unites_flutter/src/blocs/EventsBloc.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/resources/EventRepository.dart';
import 'package:unites_flutter/src/ui/events/CreateEventScreen.dart';
import 'package:unites_flutter/src/ui/events/EventInfoScreen.dart';
import 'package:unites_flutter/src/ui/widgets/LittleWidgetsCollection.dart';

class EventsListScreen extends StatefulWidget {
  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  final eventBloc = EventsBloc();

  @override
  void initState() {
    super.initState();
    eventBloc.addEventsListener();
    eventBloc.getEvents();
  }

  @override
  void dispose() {
    eventBloc.dispose();
    super.dispose();
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
          padding: EdgeInsets.all(10),
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: StreamBuilder<List<EventModel>>(
            stream: eventBloc.events,
            builder: (BuildContext context,
                AsyncSnapshot<List<EventModel>> snapshot) {
              Widget child;
              var bufferWidgets = <Widget>[];
              if (snapshot.hasData) {
                snapshot.data.forEach((element) {
                  bufferWidgets.add(Card(
                      child: ListTile(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => EventInfoScreen(eventId: element.id)));
                        },
                    title: Text('${element.name}'),
                    subtitle: Text('${element.company}'),
                  )));
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
