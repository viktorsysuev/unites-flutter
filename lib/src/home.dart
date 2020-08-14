import 'package:flutter/material.dart';
import 'package:unites_flutter/main.dart';
import 'package:unites_flutter/src/blocs/event_bloc.dart';
import 'package:unites_flutter/src/blocs/notification_bloc.dart';
import 'package:unites_flutter/src/blocs/user_bloc.dart';
import 'package:unites_flutter/src/ui/contacts/contacts_list_screen.dart';
import 'package:unites_flutter/src/ui/events/main_events_screen.dart';
import 'package:unites_flutter/src/ui/notifications/notificatons_screen.dart';
import 'package:unites_flutter/src/ui/profile/profile_main_screen.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final userBloc = getIt<UsersBloc>();
  final notificationBloc = getIt<NotificationBloc>();

  final List<Widget> _children = [
    MainEventsScreen(),
    ContactsListScreen(),
    NotificationScreen(),
    ProfileMainScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    userBloc.initUsers();
    notificationBloc.initNotifications();
    notificationBloc.addNotificationsListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        onTap: onTabTapped, // new
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            title: Text('Мероприятия'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text('Контакты'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Уведомления'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Профиль'))
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
