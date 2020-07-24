import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/src/database/DatabaseProvider.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/resources/EventRepository.dart';

class EventsBloc {
  final _eventRepository = EventRepository();

  final _eventFetcher = PublishSubject<EventModel>();

  final _eventsController = StreamController<List<EventModel>>.broadcast();

  Stream<List<EventModel>> get events => _eventsController.stream;

  Stream<EventModel> get getEvent => _eventFetcher.stream;

  final _addEventsController = StreamController<EventModel>.broadcast();

  StreamSink<EventModel> get inAddEvent => _addEventsController.sink;

  EventsBloc() {
    events;

    _addEventsController.stream.listen(_handleAddEvent);
  }

  void getEvents() async {
    var events = await _eventRepository.getAllEvents();
    _eventsController.sink.add(events);
  }

  void addListener() async {
    var firestoreDB = Firestore.instance;
    firestoreDB.collection('events').snapshots().listen((event) {
      event.documentChanges.forEach((element) {
        if (element.type == DocumentChangeType.added) {
          var event = EventModel.fromJson(element.document.data);
          DatabaseProvider.db.insertData('events', event.toMap());
          inAddEvent.add(event);
        }
      });
    });
  }

  createEvent(EventModel eventModel) {
    inAddEvent.add(eventModel);
    _eventRepository.addNewEvent(eventModel);
  }

  initEvetns() async {
    var events = await _eventRepository.initEvents();
    _eventsController.sink.add(events);
  }

  fetchEvent(String eventId) {
    _eventRepository
        .getEvent(eventId)
        .then((value) => _eventFetcher.sink.add(value));
  }

  dispose() {
    _addEventsController.close();
    _eventsController.close();
  }

  void _handleAddEvent(EventModel event) async {
    await DatabaseProvider.db.insertData('events', event.toMap());
    getEvents();
  }
}
