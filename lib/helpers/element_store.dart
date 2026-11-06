import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DefaultView { list, table }

class ElementStore extends ChangeNotifier {
  final SharedPreferences? _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  DefaultView _defaultView = DefaultView.list;

  ElementStore([this._prefs]) {
    final savedTheme = _prefs?.getString('themeMode');
    _themeMode = switch (savedTheme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final savedView = _prefs?.getString('defaultView');
    _defaultView = switch (savedView) {
      'table' => DefaultView.table,
      _ => DefaultView.list,
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

  DefaultView get defaultView => _defaultView;

  void setDefaultView(DefaultView view) {
    if (_defaultView == view) return;
    _defaultView = view;
    _prefs?.setString('defaultView', view.name);
    notifyListeners();
  }
}
