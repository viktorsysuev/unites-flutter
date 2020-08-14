import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unites_flutter/injection.dart';
import 'package:unites_flutter/src/app.dart';
import 'package:unites_flutter/src/resources/user_repository.dart';
import 'package:unites_flutter/src/util/theme_controller.dart';


final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection(Env.dev, getIt);
  final prefs = await SharedPreferences.getInstance();
  final themeController = ThemeController(prefs);
  runApp(App(themeController: themeController));
}
