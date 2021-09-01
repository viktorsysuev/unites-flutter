import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:unites_flutter/domain/interactors/event_interactor.dart';
import 'package:unites_flutter/domain/models/image_collection.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/data/database/database_provider.dart';
import 'package:unites_flutter/domain/models/comment_with_user.dart';
import 'package:unites_flutter/domain/models/event_model.dart';
import 'package:unites_flutter/domain/models/event_with_participants.dart';
import 'package:unites_flutter/domain/models/participants_model.dart';
import 'package:unites_flutter/domain/models/user_model.dart';

@injectable
class EventsBloc {
  EventsBloc() {
    events;
    eventWithParticipants;
    participants;
    _addEventsController.stream.listen(_handleAddEvent);
  }

  final _eventInteractor = getIt<EventInteractor>();

  final _eventFetcher = StreamController<EventModel>.broadcast();

  final _eventsController = StreamController<List<EventModel>>.broadcast();

  final _participantsController = StreamController<List<UserModel>>.broadcast();

  final _commentsController =
      StreamController<List<CommentWithUser>>.broadcast();

  final _myEventsWithParticipantsController =
      StreamController<List<EventWithParticipants>>.broadcast();

  final _eventWithParticipantsController =
      StreamController<EventWithParticipants>.broadcast();

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

  final _images = StreamController<EventImagesModel?>();

  Stream<EventImagesModel?> get images => _images.stream;

  void getEvents() async {
    var events = await _eventInteractor.getAllEvents();
    _eventsController.sink.add(events);
  }

  void getEventWithParticipants(String eventId) async {
    var event = await _eventInteractor.getEvent(eventId);
    var participants = await _eventInteractor.getEventParticipants(eventId);
    var res = EventWithParticipants();
    res.eventModel = event;
    res.participants = participants;
    _eventWithParticipantsController.sink.add(res);
  }

  void addEventsListener() async {
    var firestoreDB = FirebaseFirestore.instance;
    firestoreDB.collection('events').snapshots().listen((event) {
      event.docChanges.forEach((element) async {
        if (element.type == DocumentChangeType.added) {
          if (element.doc.data() == null) return;
          var event =
              EventModel.fromJson(element.doc.data()!);
          await DatabaseProvider.db.insertData('events', event.toMap());
          inAddEvent.add(event);
          getMyEventsWithParticipants();
        } else if (element.type == DocumentChangeType.removed) {
          if (element.doc.data() == null) return;
          var event =
              EventModel.fromJson(element.doc.data()!);
          DatabaseProvider.db.deleteEvent(event.id);
          getEvents();
          getMyEventsWithParticipants();
        }
      });
    });
  }

  void getMyEventsWithParticipants() async {
    var events = await _eventInteractor.getMyEvents();
    _myEventsWithParticipantsController.sink.add(events);
  }

  void addParticipantsListener() async {
    var firestoreDB = FirebaseFirestore.instance;
    firestoreDB
        .collectionGroup('participants')
        .snapshots()
        .listen((participant) {
      participant.docChanges.forEach((element) async {
        if (element.type == DocumentChangeType.modified) {
          if (element.doc.data() == null) return;
          var participant = ParticipantsModel.fromJson(element.doc
              .data()!);
          await DatabaseProvider.db
              .insertData('participants', participant.toJson());
          getEventWithParticipants(participant.eventId);
          getMyEventsWithParticipants();
        } else if (element.type == DocumentChangeType.removed) {
          print('listener removed');
          if (element.doc.data() == null) return;
          var participant = ParticipantsModel.fromJson(element.doc.data()!);
          DatabaseProvider.db
              .deleteParticipant(participant.eventId, participant.userId);
          getEventWithParticipants(participant.eventId);
          getMyEventsWithParticipants();
        }
      });
    });
  }

  getEventParticipants(String eventId) async {
    var participants =
        await _eventInteractor.getEventParticipantsFromDB(eventId);
    _participantsController.sink.add(participants);
  }

  getEventCommetns(String eventId) async {
    var comments = await _eventInteractor.getEventComments(eventId);
    _commentsController.sink.add(comments);
  }

  void getEventImages(String eventId) async{
    var images = await _eventInteractor.getEventImages(eventId);
    _images.sink.add(images);
  }

  sendComment(String text, String eventId) async {
    _eventInteractor.addNewComment(text, eventId);
    getEventCommetns(eventId);
  }

  createEvent(EventModel eventModel, {EventImagesModel? images}) {
    inAddEvent.add(eventModel);
    _eventInteractor.addNewEvent(eventModel, images: images);
  }

  joinEvent(String eventId) async {
    _eventInteractor.joinEvent(eventId);
  }

  leftEvent(String eventId) async {
    _eventInteractor.leftEvent(eventId);
  }

//  bool isMember(String eventId) {
//    var firestoreDB = Firestore.instance;
//    firestoreDB.collection('events')
//  }

  initEvetns() async {
    var events = await _eventInteractor.initEvents();
    _eventsController.sink.add(events);
  }

  fetchEvent(String eventId) {
    _eventInteractor
        .getEvent(eventId)
        .then((value) => _eventFetcher.sink.add(value));
  }

  Future<bool> isMember(String eventId) async {
    return await _eventInteractor.isParticipant(eventId);
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
