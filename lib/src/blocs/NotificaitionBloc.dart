import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unites_flutter/src/database/DatabaseProvider.dart';
import 'package:unites_flutter/src/models/NotificationModel.dart';
import 'package:unites_flutter/src/resources/NotificationRepository.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';

class NotificationBloc {
  final notificationRepository = NotificationRepository();
  final userRepository = UserRepository();

  final _notificationsController =
      StreamController<List<NotificationModel>>.broadcast();

  Stream<List<NotificationModel>> get notifications =>
      _notificationsController.stream;


  void initNotifications(){
    notificationRepository.initNotifications();
  }

  getNotifications() async {
    var notifications = await notificationRepository.getNotifications();
    _notificationsController.sink.add(notifications);
  }


  void addNotificationsListener() async {
    var firestore = Firestore.instance;
    var currentUserId = await userRepository.getCurrentUserId();
    firestore.collection('users').document(currentUserId).collection('notifications').snapshots().listen((event) {
      event.documentChanges.forEach((element) async {
        if(element.type == DocumentChangeType.modified){
          await DatabaseProvider.db.insertData('notifications', NotificationModel.fromJson(element.document.data).toMap());
          getNotifications();
        }
      });
    });
  }
}
