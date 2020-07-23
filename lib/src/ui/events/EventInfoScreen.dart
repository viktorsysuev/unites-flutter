import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unites_flutter/src/blocs/EventsBloc.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
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

  @override
  void initState() {
    super.initState();
    eventBloc.fetchEvent(widget.eventId);
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
          child: StreamBuilder<EventModel>(
            stream: eventBloc.getEvent,
            builder:
                (BuildContext context, AsyncSnapshot<EventModel> snapshot) {
              Widget child;
              if (snapshot.hasData) {
                child = SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Container(margin: EdgeInsets.only(top: 16.0, bottom: 8.0)),
                    Center(
                      child: Text('${snapshot.data.name}',
                          style: TextStyle(fontSize: 22.0)),
                    ),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Center(
                      child: Text('${snapshot.data.description}',
                          style: TextStyle(fontSize: 16.0)),
                    ),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Center(
                      child: Text('${snapshot.data.company}',
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
                            Text('${snapshot.data.address}',
                                style: TextStyle(fontSize: 16.0)),
                            Container(margin: EdgeInsets.only(top: 16.0)),
                            Text('Начало:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text('${formatter.format(snapshot.data.start)}',
                                style: TextStyle(fontSize: 16.0)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text('Конец:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Container(margin: EdgeInsets.only(top: 8.0)),
                            Text('${formatter.format(snapshot.data.end)}',
                                style: TextStyle(fontSize: 16.0)),
                          ]),
                    ),
                    Container(margin: EdgeInsets.only(top: 20.0, bottom: 20.0)),
                    Center(
                      child: RaisedButton(
                        color: Colors.lightBlue,
                        child: Text('Вступить'),
                        onPressed: () {},
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
