import 'package:flutter/material.dart';
import 'package:unites_flutter/src/ui/auth/IntroScreen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: IntroScreen(),
      ),
    );
  }
}