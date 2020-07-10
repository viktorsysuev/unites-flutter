import 'package:flutter/material.dart';
import 'package:unites_flutter/ui/auth/InputCodeScreen.dart';

class InputPhoneNumberScreen extends StatelessWidget {

  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 220.0),
            Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text('Вход', style: TextStyle(fontSize: 22.0),),
              ],
            ),
            SizedBox(height: 60.0),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Телефон',
              ),
            ),
            SizedBox(height: 30.0),
            Center(
              child: RaisedButton(
                color: Colors.lightBlue,
                textColor: Colors.white,
                child: Text('Отправить'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InputCodeScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


