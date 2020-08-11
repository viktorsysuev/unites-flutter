import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unites_flutter/src/database/DatabaseProvider.dart';
import 'package:unites_flutter/src/models/NotificationModel.dart';
import 'package:unites_flutter/src/models/NotificationState.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';

class NotificationRepository {

  final userRepository = UserRepository();

  final firestore = Firestore.instance;

  void initNotifications() async {
    var currentUserId = await userRepository.getCurrentUserId();
    var notifications = await firestore
        .collection('users')
        .document(currentUserId)
        .collection('notifications')
        .getDocuments();
    notifications.documents.forEach((element) {
      print('insert notification ${element.data}');
      DatabaseProvider.db.insertData('notifications', NotificationModel.fromJson(element.data).toMap());
    });
  }

  Future<List<NotificationModel>> getNotifications() async {
      return DatabaseProvider.db.getUserNotifications();
  }

}
