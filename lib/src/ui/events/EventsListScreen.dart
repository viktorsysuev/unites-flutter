
import 'package:flutter/material.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/resources/EventRepository.dart';



class EventsListScreen extends StatelessWidget{

  EventRepository eventRepository = EventRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мероприятия'),
      ),
      body: Center(
        child: ListView(children: <Widget>[
          SizedBox(height: 220.0),
          Column(
            children: <Widget>[
              SizedBox(height: 16.0),
              Text(
                'Unites',
                style: TextStyle(fontSize: 26.0),
              ),
            ],
          ),
          SizedBox(height: 40.0),
          Center(
            child: RaisedButton(
              color: Colors.lightBlue,
              textColor: Colors.white,
              child: Text('Мероприятия'),
              onPressed: () {
                final event = EventModel();
                event.id = "1";
                event.name = "Тестовое меоприятие";
                event.description = "Для тестае";
                eventRepository.addNewEvent(event);
              },
            ),
          ),
        ]),
      ),
    );
  }



}