import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  late bool _isLightTheme = true;
  static const String _themeKey = 'isLightTheme';

  bool get isLightTheme => _isLightTheme;

  ThemeManager() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isLightTheme = prefs.getBool(_themeKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isLightTheme = !_isLightTheme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, _isLightTheme);
  }
}
