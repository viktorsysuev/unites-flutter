import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unites_flutter/di/injection.dart';
import 'package:unites_flutter/ui/app.dart';
import 'package:unites_flutter/ui/util/theme_controller.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureInjection(Env.dev, getIt);
  final prefs = await SharedPreferences.getInstance();
  final themeController = ThemeController(prefs);
  runApp(App(themeController: themeController));
}
