import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unites_flutter/ui/auth/input_phone_number_screen.dart';

import '../home.dart';

class IntroScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    getUser(context);
    return Scaffold();
  }

  void getUser(BuildContext context) async {
    final user = _auth.currentUser;
    if (user != null) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InputPhoneNumberScreen()),
      );
    }
  }
}
