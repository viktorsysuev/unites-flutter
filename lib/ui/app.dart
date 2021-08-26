import 'package:flutter/material.dart';
import 'package:unites_flutter/ui/auth/intro_screen.dart';
import 'package:unites_flutter/ui/util/theme_controller.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.themeController}) : super(key: key);

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return ThemeControllerProvider(
          controller: themeController,
          child: MaterialApp(
            theme: _buildCurrentTheme(),
            home: IntroScreen(),
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
