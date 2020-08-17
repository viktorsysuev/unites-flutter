import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:unites_flutter/main.dart';
import 'package:unites_flutter/src/database/database_provider.dart';
import 'package:unites_flutter/src/models/notification_model.dart';
import 'package:unites_flutter/src/models/notification_state.dart';
import 'package:unites_flutter/src/resources/user_repository.dart';


@injectable
class NotificationRepository {

  var userRepository = getIt<UserRepository>();

  final firestore = Firestore.instance;

  void initNotifications() async {
    var currentUserId = await userRepository.getCurrentUserId();
    var notifications = await firestore
        .collection('users')
        .document(currentUserId)
        .collection('notifications')
        .getDocuments();
    notifications.documents.forEach((element) {
      DatabaseProvider.db.insertData('notifications', NotificationModel.fromJson(element.data).toMap());
    });
  }

  Future<List<NotificationModel>> getNotifications() async {
    return DatabaseProvider.db.getUserNotifications();
  }

  Future<int> getUnreadCountNotifications() async {
    return DatabaseProvider.db.getUnreadCountNotifications();
  }

  Future<void> setNotificationsAsRead() async {
    await DatabaseProvider.db.setNotificationsAsRead();
    var currentUserId = await userRepository.getCurrentUserId();
    await firestore
        .collection('users')
        .document(currentUserId)
        .collection('notifications')
        .getDocuments().then((value) => {
          value.documents.forEach((element) {
            element.reference.updateData({'seenByMe': true});
          })
    });
  }
}
