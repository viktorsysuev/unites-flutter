import 'package:flutter/material.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/resources/EventRepository.dart';
import 'package:unites_flutter/src/ui/events/CreateEventScreen.dart';

class EventsListScreen extends StatelessWidget {
  EventRepository eventRepository = EventRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мероприятия'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateEventScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
