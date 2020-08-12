import 'package:flutter/material.dart';
import 'package:unites_flutter/src/blocs/event_bloc.dart';
import 'package:unites_flutter/src/blocs/notificaition_bloc.dart';
import 'package:unites_flutter/src/models/event_model.dart';
import 'package:unites_flutter/src/models/notification_model.dart';
import 'package:unites_flutter/src/models/notification_state.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();

  void someFunction() {

  }

  final _publicNotificationsBloc = NotificationBloc();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificationsBloc = NotificationBloc();
  final privateNotificationsBloc = NotificationBloc();

  @override
  void initState() {
    notificationsBloc.getNotifications();
    notificationsBloc.addNotificationsListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Уведомления')),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: StreamBuilder<List<NotificationModel>>(
            stream: notificationsBloc.notifications,
            builder: (BuildContext context,
                AsyncSnapshot<List<NotificationModel>> snapshot) {
              Widget child;
              var bufferWidgets = <Widget>[];
              if (snapshot.hasData) {
                snapshot.data.forEach((element) {
                  bufferWidgets.add(Padding(
                      padding: EdgeInsets.only(left: 6, right: 6, top: 4),
                      child: Card(
                          child: ListTile(
                        onTap: () {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) =>
//                                          EventInfoScreen(eventId: element.id)));
                        },
                        title: Text('${getNotificationText(element)}'),
                      ))));
                });

                child = Column(
                  children: bufferWidgets,
                  crossAxisAlignment: CrossAxisAlignment.start,
                );
              } else {
                child = Container();
              }
              return child;
            },
          ),
        ));
  }

  String getNotificationText(NotificationModel notificationModel) {
    var res = '';

    if(notificationModel.state == NotificationState.EVENT_CHANGED){
      res = 'Мероприятие  `${notificationModel.eventName}` изменилось';
    } else if(notificationModel.state == NotificationState.EVENT_NEW_PARTICIPANT){
      res = '${notificationModel.initiatorName} вступил в Ваше мероприятие `${notificationModel.eventName}`';
    } else {
      res = '${notificationModel.initiatorName} прокомментировал ваше мероприятие `${notificationModel.eventName}`';
    }

    return res;
  }
}
