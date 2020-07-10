import 'package:flutter/material.dart';
import 'package:unites_flutter/ui/auth/InputPhoneNumberScreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Unites',
    home: IntroScreen(),
  ));
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(children: <Widget>[
          SizedBox(height: 220.0),
          Column(
            children: <Widget>[
              SizedBox(height: 16.0),
              Text(
                'Unites',
                style: TextStyle(fontSize: 26.0),
              ),
            ],
          ),
          SizedBox(height: 40.0),
          Center(
            child: RaisedButton(
              color: Colors.lightBlue,
              textColor: Colors.white,
              child: Text('Войти'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InputPhoneNumberScreen()),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
