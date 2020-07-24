import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unites_flutter/src/database/DatabaseProvider.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/models/ParticipantsModel.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';

class EventRepository {
  final db = Firestore.instance;
  final userRepository = UserRepository();

  Future<List<EventModel>> initEvents() async {
    var events = List<EventModel>();
    var docs = await db.collection('events').getDocuments();
    docs.documents.forEach((element) {
      events.add(EventModel.fromJson(element.data));
      DatabaseProvider.db
          .insertData('events', EventModel.fromJson(element.data).toMap());
    });
    return events;
  }

  Future<EventModel> addNewEvent(EventModel event) async {
    var userId = await userRepository.getCurrentUserId();
    var currentUser = await userRepository.getUser(userId);
    ParticipantsModel participant;
    await db.collection('events').add(event.toJson()).then((value) => {
          participant = ParticipantsModel(),
          participant.id = currentUser.id,
          participant.eventId = value.documentID,
          participant.userId = currentUser.id,
          participant.role = 'member',
          db
              .collection('events')
              .document(value.documentID)
              .collection('participants')
              .add(participant.toJson()),
          event.id = value.documentID,
          DatabaseProvider.db.insertData('events', event.toMap()),
          updateEvent(event)
        });
  }

  Future<EventModel> updateEvent(EventModel event) async {
    await db.collection('events').document(event.id).updateData(event.toJson());
  }

  Future<List<EventModel>> getAllEvents() async {
    var events = await initEvents();
    return events;
  }

  Future<List<EventModel>> getAllEventsFromDB() async {
    return DatabaseProvider.db.getAllEvents();
  }

  Future<EventModel> getEvent(String eventId) async {
    return DatabaseProvider.db.getEvent(eventId);
  }

  Future<List<ParticipantsModel>> getEventParticipants(String eventId) async {
    var participants = <ParticipantsModel>[];
    await db
        .collection('events')
        .document(eventId)
        .collection('participants')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              participants.add(ParticipantsModel.fromJson(element.data));
            }));
    return participants;
  }
}
