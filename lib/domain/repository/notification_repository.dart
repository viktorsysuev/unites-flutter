import 'package:unites_flutter/domain/models/notification_model.dart';

abstract class NotificationRepository {
  void initNotifications();

  Future<List<NotificationModel>> getNotifications();

  Future<int> getUnreadCountNotifications();

  void setNotificationsAsRead();
}
