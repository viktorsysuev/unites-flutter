import 'package:flutter/material.dart';

class InputCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 220.0),
            Column(children: [
              Text('Введите проверочный код', style: TextStyle(fontSize: 22.0)),
            ]),
            SizedBox(height: 40.0),
            TextField(
              decoration:
                  InputDecoration(filled: true, labelText: 'Проверочный код'),
            ),
          ],
        ),
      ),
    );
  }
}
