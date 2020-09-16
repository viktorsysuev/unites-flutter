


import 'package:injectable/injectable.dart';
import 'package:unites_flutter/domain/models/notification_model.dart';
import 'package:unites_flutter/domain/repository/notification_repository.dart';

@injectable
class NotificationInteractor {

  NotificationInteractor(this.notificationRepository);

  NotificationRepository notificationRepository;


  void initNotifications(){
    notificationRepository.initNotifications();
  }

  Future<List<NotificationModel>> getNotifications(){
    return notificationRepository.getNotifications();
  }

  Future<int> getUnreadCountNotifications(){
    return notificationRepository.getUnreadCountNotifications();
  }

  void setNotificationsAsRead(){
    notificationRepository.setNotificationsAsRead();
  }

}