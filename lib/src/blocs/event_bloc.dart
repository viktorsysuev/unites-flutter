import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/src/database/database_provider.dart';
import 'package:unites_flutter/src/models/comment_model.dart';
import 'package:unites_flutter/src/models/comment_with_user.dart';
import 'package:unites_flutter/src/models/event_model.dart';
import 'package:unites_flutter/src/models/event_with_members.dart';
import 'package:unites_flutter/src/models/event_with_participants.dart';
import 'package:unites_flutter/src/models/participants_model.dart';
import 'package:unites_flutter/src/models/user_model.dart';
import 'package:unites_flutter/src/resources/event_repository.dart';

class EventsBloc {
  final _eventRepository = EventRepository();

  final _eventFetcher = StreamController<EventModel>.broadcast();

  final _eventsController = StreamController<List<EventModel>>.broadcast();

  final _participantsController = StreamController<List<UserModel>>.broadcast();

  final _commentsController = StreamController<List<CommentWithUser>>.broadcast();

  final _myEventsWithParticipantsController = StreamController<List<EventWithParticipants>>.broadcast();

  final _eventWithParticipantsController = StreamController<EventWithParticipants>.broadcast();

  Stream<List<EventModel>> get events => _eventsController.stream;

  Stream<List<UserModel>> get participants => _participantsController.stream;

  Stream<List<CommentWithUser>> get comments => _commentsController.stream;

  Stream<EventWithParticipants> get eventWithParticipants =>
      _eventWithParticipantsController.stream;

  Stream<List<EventWithParticipants>> get myEventsWithParticipants =>
      _myEventsWithParticipantsController.stream;

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
      event.documentChanges.forEach((element) async {
        if (element.type == DocumentChangeType.added) {
          var event = EventModel.fromJson(element.document.data);
          await DatabaseProvider.db.insertData('events', event.toMap());
          inAddEvent.add(event);
          getMyEventsWithParticipants();
        } else if (element.type == DocumentChangeType.removed) {
          var event = EventModel.fromJson(element.document.data);
          await DatabaseProvider.db.deleteEvent(event.id);
          getEvents();
          getMyEventsWithParticipants();
        }
      });
    });
  }

  void getMyEventsWithParticipants() async {
    var events = await _eventRepository.getMyEvents();
    _myEventsWithParticipantsController.sink.add(events);
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
          await DatabaseProvider.db
              .insertData('participants', participant.toJson());
          getEventWithParticipants(participant.eventId);
          getMyEventsWithParticipants();
        } else if (element.type == DocumentChangeType.removed) {
          print('listener removed');
          var participant = ParticipantsModel.fromJson(element.document.data);
          await DatabaseProvider.db
              .deleteParticipant(participant.eventId, participant.userId);
          getEventWithParticipants(participant.eventId);
          getMyEventsWithParticipants();
        }
      });
    });
  }

  getEventParticipants(String eventId) async {
    var participants =
        await _eventRepository.getEventParticipantsFomDB(eventId);
    _participantsController.sink.add(participants);
  }

  getEventCommetns(String eventId) async {
    var comments = await _eventRepository.getEventComments(eventId);
    _commentsController.sink.add(comments);
  }

  sendComment(String text, String eventId) async {
    await _eventRepository.addNewComment(text, eventId);
    getEventCommetns(eventId);
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
