import 'package:flutter/material.dart';
import 'package:unites_flutter/src/blocs/EventsBloc.dart';
import 'package:unites_flutter/src/blocs/NotificaitionBloc.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/models/NotificationModel.dart';
import 'package:unites_flutter/src/models/NotificationState.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificationsBloc = NotificationBloc();

  @override
  void initState() {
    notificationsBloc.getNotifications();
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
                      padding: EdgeInsets.only(left: 8, right: 8),
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
      res = 'Какое-то мероприятие изменилось';
    } else if(notificationModel.state == NotificationState.EVENT_NEW_PARTICIPANT){
      res = 'Кто-то вступил в Ваше мероприятие';
    } else {
      res = 'Кто-то прокомментировал ваше мероприятие';
    }

    return res;
  }
}
