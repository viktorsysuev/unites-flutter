import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unites_flutter/src/database/DatabaseProvider.dart';
import 'package:unites_flutter/src/models/CommentModel.dart';
import 'package:unites_flutter/src/models/CommentWithUser.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/models/EventWithMembers.dart';
import 'package:unites_flutter/src/models/EventWithParticipants.dart';
import 'package:unites_flutter/src/models/ParticipantsModel.dart';
import 'package:unites_flutter/src/models/UserModel.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';

class EventRepository {
  final db = Firestore.instance;
  final userRepository = UserRepository();

  Future<List<EventModel>> initEvents() async {
    var events = List<EventModel>();
    var docs = await db.collection('events').getDocuments();
    docs.documents.forEach((element) {
      element.reference
          .collection('participants')
          .getDocuments()
          .then((value) => {
                value.documents.forEach((element) {
                  DatabaseProvider.db.insertData('participants', element.data);
                })
              });
      element.reference.collection('comments').getDocuments().then((value) => {
            value.documents.forEach((element) {
              DatabaseProvider.db.insertData(
                  'comments', CommentModel.fromJson(element.data).toMap());
            })
          });
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
    event.owner = userId;
    await db.collection('events').add(event.toJson()).then((value) => {
          participant = ParticipantsModel(),
          participant.eventId = value.documentID,
          participant.userId = currentUser.userId,
          participant.avatar = currentUser.avatar,
          participant.firstName = currentUser.firstName,
          participant.lastName = currentUser.lastName,
          participant.role = 'owner',
          db
              .collection('events')
              .document(value.documentID)
              .collection('participants')
              .add(participant.toJson())
              .then((value) => {
                    participant.docId = value.documentID,
                    DatabaseProvider.db
                        .insertData('participants', participant.toJson()),
                    db
                        .collection('events')
                        .document(participant.eventId)
                        .collection('participants')
                        .document(value.documentID)
                        .updateData(participant.toJson())
                  }),
          event.id = value.documentID,
          DatabaseProvider.db.insertData('events', event.toMap()),
          updateEvent(event)
        });
  }

  void addNewComment(String text, String eventId) async {
    var userId = await userRepository.getCurrentUserId();
    var currentUser = await userRepository.getUser(userId);
    var newComment = CommentModel();
    newComment.eventId = eventId;
    newComment.authorId = userId;
    newComment.createdAt = DateTime.now();
    newComment.text = text;
    await db
        .collection('events')
        .document(eventId)
        .collection('comments')
        .add(newComment.toJson())
        .then((value) => {
              newComment.commentId = value.documentID,
              value.updateData(newComment.toJson()),
              DatabaseProvider.db.insertData('comments', newComment.toMap())
            });
  }

  joinEvent(String eventId) async {
    var userId = await userRepository.getCurrentUserId();
    var user = await userRepository.getUser(userId);
    var participant = ParticipantsModel(
        userId: userId,
        eventId: eventId,
        avatar: user.avatar,
        firstName: user.firstName,
        lastName: user.lastName,
        role: 'member');
    await db
        .collection('events')
        .document(eventId)
        .collection('participants')
        .add(participant.toJson())
        .then((value) => {
              print('update participant ${value.documentID}'),
              participant.docId = value.documentID,
              DatabaseProvider.db
                  .insertData('participants', participant.toJson()),
              db
                  .collection('events')
                  .document(eventId)
                  .collection('participants')
                  .document(value.documentID)
                  .updateData(participant.toJson())
            });
  }

  leftEvent(String eventId) async {
    var userId = await userRepository.getCurrentUserId();
    var participant = await DatabaseProvider.db.getParticipant(eventId, userId);
    await DatabaseProvider.db.deleteParticipant(eventId, userId);
    print("delete ${participant.docId}");
    await db
        .collection('events')
        .document(eventId)
        .collection('participants')
        .document(participant.docId)
        .delete();
  }

  Future<EventModel> updateEvent(EventModel event) async {
    await db.collection('events').document(event.id).updateData(event.toJson());
  }

  Future<List<EventModel>> getAllEvents() async {
    var events = await initEvents();
    return events;
  }

  Future<List<UserModel>> getEventParticipantsFomDB(String eventId) async {
    return DatabaseProvider.db.getEventParticipants(eventId);
  }

  Future<List<CommentWithUser>> getEventComments(String eventId) async {
    return DatabaseProvider.db.getEventComments(eventId);
  }

  Future<List<EventWithParticipants>> getMyEvents() async {
    var currentUserId = await userRepository.getCurrentUserId();
    var events = await DatabaseProvider.db.getMyEvents(currentUserId);
    return events;
  }

  Future<List<EventModel>> getAllEventsFromDB() async {
    return DatabaseProvider.db.getAllEvents();
  }

  void deleteEvent(String eventId) async {
    DatabaseProvider.db.deleteEvent(eventId);
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

  Future<bool> isParticipant(String eventId) async {
    var userId = await userRepository.getCurrentUserId();
    var count = await DatabaseProvider.db.idParticipant(eventId, userId);
    return count > 0;
  }
}
