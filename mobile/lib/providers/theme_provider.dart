
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark as per design
  bool _isBlurEnabled = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isBlurEnabled => _isBlurEnabled;

  ThemeProvider() {
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? true; // Default true
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _isBlurEnabled = prefs.getBool('isBlurEnabled') ?? false;
    notifyListeners();
  }

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    notifyListeners();
  }

  void toggleBlur(bool value) async {
    _isBlurEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBlurEnabled', value);
    notifyListeners();
  }
}

