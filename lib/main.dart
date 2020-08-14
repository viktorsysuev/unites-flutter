import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unites_flutter/src/app.dart';
import 'package:unites_flutter/src/util/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final themeController = ThemeController(prefs);
  runApp(App(themeController: themeController));
}
