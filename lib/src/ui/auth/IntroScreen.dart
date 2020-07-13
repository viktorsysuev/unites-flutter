import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unites_flutter/src/ui/auth/InputPhoneNumberScreen.dart';

import '../../Home.dart';

class IntroScreen extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    getUser(context);
    return Scaffold();
  }


  void getUser(BuildContext context) async {
    final FirebaseUser user = await _auth.currentUser();
    if (user != null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InputPhoneNumberScreen()),
      );
    }
  }
}