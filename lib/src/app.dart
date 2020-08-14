import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unites_flutter/src/home.dart';
import 'package:unites_flutter/src/ui/auth/intro_screen.dart';
import 'package:unites_flutter/src/util/theme_controller.dart';

class App extends StatelessWidget {
  final ThemeController themeController;

  const App({Key key, this.themeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return ThemeControllerProvider(
          controller: themeController,
          child: MaterialApp(
            theme: _buildCurrentTheme(),
            home: Home(),
          ),
        );
      },
    );
  }

  ThemeData _buildCurrentTheme() {
    switch (themeController.currentTheme) {
      case 'dark':
        return ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.orange,
        );
      case 'light':
      default:
        return ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
        );
    }
  }
}
