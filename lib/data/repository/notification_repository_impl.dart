import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:unites_flutter/domain/repository/notification_repository.dart';
import 'package:unites_flutter/domain/repository/user_repository.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/data/database/database_provider.dart';
import 'package:unites_flutter/domain/models/notification_model.dart';
import 'package:unites_flutter/domain/models/notification_state.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';


@injectable
class NotificationRepositoryImpl implements NotificationRepository {

  NotificationRepositoryImpl(this.userRepository);

  UserRepositoryImpl userRepository;

  final firestore = Firestore.instance;

  @override
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

  @override
  Future<List<NotificationModel>> getNotifications() async {
    return DatabaseProvider.db.getUserNotifications();
  }

  @override
  Future<int> getUnreadCountNotifications() async {
    return DatabaseProvider.db.getUnreadCountNotifications();
  }

  @override
  void setNotificationsAsRead() async {
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
