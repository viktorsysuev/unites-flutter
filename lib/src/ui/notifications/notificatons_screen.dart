import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unites_flutter/src/blocs/event_bloc.dart';
import 'package:unites_flutter/src/blocs/notification_bloc.dart';
import 'package:unites_flutter/src/models/event_model.dart';
import 'package:unites_flutter/src/models/notification_model.dart';
import 'package:unites_flutter/src/models/notification_state.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();

  void someFunction() {}

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
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
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
                print('empty list');
                child = Column(children: [
                  Container(
                      margin: EdgeInsets.only(top: 100),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/broke.svg',
                        width: 100,
                        height: 160,
                      )),
                  Container(padding: EdgeInsets.only(top: 16)),
                  Text('Список уведомлений пуст',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center)
                ]);
              }
              return child;
            },
          ),
        ));
  }

  String getNotificationText(NotificationModel notificationModel) {
    var res = '';

    if (notificationModel.state == NotificationState.EVENT_CHANGED) {
      res = 'Мероприятие  `${notificationModel.eventName}` изменилось';
    } else if (notificationModel.state ==
        NotificationState.EVENT_NEW_PARTICIPANT) {
      res =
          '${notificationModel.initiatorName} вступил в Ваше мероприятие `${notificationModel.eventName}`';
    } else {
      res =
          '${notificationModel.initiatorName} прокомментировал ваше мероприятие `${notificationModel.eventName}`';
    }

    return res;
  }
}
