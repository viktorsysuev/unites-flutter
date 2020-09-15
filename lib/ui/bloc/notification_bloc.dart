import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/data/database/database_provider.dart';
import 'package:unites_flutter/domain/models/notification_model.dart';
import 'package:unites_flutter/data/repository/notification_repository_impl.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';

@singleton
@injectable
class NotificationBloc {
  var firestore = Firestore.instance;
  var notificationRepository = getIt<NotificationRepositoryImpl>();
  var userRepository = getIt<UserRepositoryImpl>();
  var countNotification = 0;

  final _notificationsController =
      StreamController<List<NotificationModel>>.broadcast();
  final _notificationsUnreadCounter = StreamController<int>.broadcast();

  Stream<List<NotificationModel>> get notifications =>
      _notificationsController.stream;

  Stream<int> get countUnread => _notificationsUnreadCounter.stream;

  void initNotifications() {
    notificationRepository.initNotifications();
  }

  getNotifications() async {
    var notifications = await notificationRepository.getNotifications();
    _notificationsController.sink.add(notifications);
  }

  getUnreadNotification() async {
    var count = await notificationRepository.getUnreadCountNotifications();
    print('getUnreadNotification $count');
    _notificationsUnreadCounter.sink.add(count);
  }

  Future<void> setNotificationsAsRead() async {
    await notificationRepository.setNotificationsAsRead();
    getUnreadNotification();
  }

  void addNotificationsListener() async {
    var currentUserId = await userRepository.getCurrentUserId();
    firestore
        .collection('users')
        .document(currentUserId)
        .collection('notifications')
        .snapshots()
        .listen((event) {
      event.documentChanges.forEach((element) async {
        if (element.type == DocumentChangeType.modified) {
          await DatabaseProvider.db.insertData('notifications',
              NotificationModel.fromJson(element.document.data).toMap());
          getNotifications();
          getUnreadNotification();
        }
      });
    });
  }
}
