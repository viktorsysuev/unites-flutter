import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unites_flutter/src/models/EventModel.dart';



class EventRepository {

  final db = Firestore.instance;


  Future<EventModel> addNewEvent(EventModel event) async {
    db.collection('events').add(event.toJson()).then((value) => {
      event.id = value.documentID,
      updateEvent(event),
    });
  }

  Future<EventModel> updateEvent(EventModel event) async {
    db.collection('events').document(event.id).updateData(event.toJson());
  }
}


