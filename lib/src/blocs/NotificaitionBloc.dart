import 'dart:async';

import 'package:unites_flutter/src/models/NotificationModel.dart';
import 'package:unites_flutter/src/resources/NotificationRepository.dart';

class NotificationBloc {
  final notificationRepository = NotificationRepository();

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
}
