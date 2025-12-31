import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages theme mode for the application
class ThemeManager extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  final SharedPreferences _prefs;

  ThemeManager(this._prefs) {
    _loadTheme();
  }

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if dark mode is active
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // In system mode, we can't know for sure without BuildContext
      return false;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// Load saved theme from storage
  Future<void> _loadTheme() async {
    final themeIndex = _prefs.getInt(_themeKey);
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
      notifyListeners();
    }
  }

  /// Set theme mode and persist
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt(_themeKey, mode.index);
    notifyListeners();
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
}

