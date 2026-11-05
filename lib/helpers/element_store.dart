import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElementStore extends ChangeNotifier {
  final SharedPreferences? _prefs;
  ThemeMode _themeMode = ThemeMode.system;

  ElementStore([this._prefs]) {
    final saved = _prefs?.getString('themeMode');
    _themeMode = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  static Future<ElementStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ElementStore(prefs);
  }

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _prefs?.setString('themeMode', mode.name);
    notifyListeners();
  }
}
