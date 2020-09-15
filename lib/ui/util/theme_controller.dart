import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const themePrefKey = 'theme';

  ThemeController(this._prefs) {
    _currentTheme = _prefs.getString(themePrefKey) ?? 'dark';
  }

  final SharedPreferences _prefs;
  String _currentTheme;

  String get currentTheme => _currentTheme;

  void setTheme(String theme) {
    _currentTheme = theme;

    notifyListeners();

    _prefs.setString(themePrefKey, theme);
  }

  static ThemeController of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ThemeControllerProvider>();
    return provider.controller;
  }
}

class ThemeControllerProvider extends InheritedWidget {
  const ThemeControllerProvider({Key key, this.controller, Widget child}) : super(key: key, child: child);

  final ThemeController controller;

  @override
  bool updateShouldNotify(ThemeControllerProvider old) => controller != old.controller;
}