import 'package:flutter/material.dart';
import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool _useSystemTheme = true;
  bool _isSystemDarkMode = false;
  bool _initialized = false;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  bool get useSystemTheme => _useSystemTheme;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void initializeSystemTheme(BuildContext context) {
    if (_initialized) return;
    _initialized = true;
    
    final brightness = MediaQuery.of(context).platformBrightness;
    _isSystemDarkMode = brightness == Brightness.dark;
    _themeData = _isSystemDarkMode ? darkMode : lightMode;
  }

  void updateSystemTheme(bool isDark) {
    _isSystemDarkMode = isDark;
    if (_useSystemTheme) {
      _themeData = isDark ? darkMode : lightMode;
      notifyListeners();
    }
  }

  void toggleTheme() {
    if (_useSystemTheme) {
      // Disable system theme and toggle manually
      _useSystemTheme = false;
      if (_themeData == lightMode) {
        themeData = darkMode;
      } else {
        themeData = lightMode;
      }
    } else {
      // Toggle between manual themes
      if (_themeData == lightMode) {
        themeData = darkMode;
      } else {
        themeData = lightMode;
      }
    }
    notifyListeners();
  }

  void enableSystemTheme() {
    _useSystemTheme = true;
    themeData = _isSystemDarkMode ? darkMode : lightMode;
    notifyListeners();
  }
}
