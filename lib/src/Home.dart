import 'package:flutter/material.dart';
import 'package:unites_flutter/src/blocs/EventsBloc.dart';
import 'package:unites_flutter/src/blocs/NotificaitionBloc.dart';
import 'package:unites_flutter/src/blocs/UsersBloc.dart';
import 'package:unites_flutter/src/ui/contacts/ContactsListScreen.dart';
import 'package:unites_flutter/src/ui/events/MainEventsScreen.dart';
import 'package:unites_flutter/src/ui/notifications/NotificatonsScreen.dart';
import 'package:unites_flutter/src/ui/profile/ProfileMainScreen.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
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
    UsersBloc().initUsers();
    NotificationBloc().initNotifications();
    NotificationBloc().addNotificationsListener();
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
