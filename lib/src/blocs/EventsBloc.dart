import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/src/database/DatabaseProvider.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/models/EventWithParticipants.dart';
import 'package:unites_flutter/src/models/ParticipantsModel.dart';
import 'package:unites_flutter/src/models/UserModel.dart';
import 'package:unites_flutter/src/resources/EventRepository.dart';

class EventsBloc {
  final _eventRepository = EventRepository();

  final _eventFetcher = PublishSubject<EventModel>();

  final _eventsController = StreamController<List<EventModel>>.broadcast();

  final _participantsController = StreamController<List<UserModel>>.broadcast();

  final _eventWithParticipantsController =
      StreamController<EventWithParticipants>.broadcast();

  Stream<List<EventModel>> get events => _eventsController.stream;

  Stream<List<UserModel>> get participants => _participantsController.stream;

  Stream<EventWithParticipants> get eventWithParticipants => _eventWithParticipantsController.stream;

  Stream<EventModel> get getEvent => _eventFetcher.stream;

  final _addEventsController = StreamController<EventModel>.broadcast();

  StreamSink<EventModel> get inAddEvent => _addEventsController.sink;

  EventsBloc() {
    events;
    eventWithParticipants;
    participants;

    _addEventsController.stream.listen(_handleAddEvent);
  }

  void getEvents() async {
    var events = await _eventRepository.getAllEvents();
    _eventsController.sink.add(events);
  }

  void getEventWithParticipants(String eventId) async {
    var event = await _eventRepository.getEvent(eventId);
    var participants = await _eventRepository.getEventParticipants(eventId);
    var res = EventWithParticipants();
    res.eventModel = event;
    res.participants = participants;
    _eventWithParticipantsController.sink.add(res);
  }

  void addEventsListener() async {
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

  void addParticipantsListener() async {
    var firestoreDB = Firestore.instance;
    firestoreDB
        .collectionGroup('participants')
        .snapshots()
        .listen((participant) {
      participant.documentChanges.forEach((element) async {
        if (element.type == DocumentChangeType.modified) {
          var participant = ParticipantsModel.fromJson(element.document.data);
          DatabaseProvider.db.insertData('participants', participant.toJson());
          getEventWithParticipants(participant.eventId);
        } else if (element.type == DocumentChangeType.removed) {
          var participant = ParticipantsModel.fromJson(element.document.data);
          DatabaseProvider.db.deleteParticipant(participant.eventId, participant.userId);
          getEventWithParticipants(participant.eventId);
        }
      });
    });
  }

  getEventParticipants(String eventId) async {
    var participants = await _eventRepository.getEventParticipantsFomDB(eventId);
    _participantsController.sink.add(participants);
  }

  createEvent(EventModel eventModel) {
    inAddEvent.add(eventModel);
    _eventRepository.addNewEvent(eventModel);
  }

  joinEvent(String eventId) async {
    await _eventRepository.joinEvent(eventId);
  }

  leftEvent(String eventId) async {
    await _eventRepository.leftEvent(eventId);
  }

//  bool isMember(String eventId) {
//    var firestoreDB = Firestore.instance;
//    firestoreDB.collection('events')
//  }

  initEvetns() async {
    var events = await _eventRepository.initEvents();
    _eventsController.sink.add(events);
  }

  fetchEvent(String eventId) {
    _eventRepository
        .getEvent(eventId)
        .then((value) => _eventFetcher.sink.add(value));
  }

  Future<bool> isMember(String eventId) async {
    return await _eventRepository.isParticipant(eventId);
  }

  dispose() {
    _addEventsController.close();
    _eventsController.close();
    _eventWithParticipantsController.close();
  }

  void _handleAddEvent(EventModel event) async {
    await DatabaseProvider.db.insertData('events', event.toMap());
    getEvents();
  }
}
