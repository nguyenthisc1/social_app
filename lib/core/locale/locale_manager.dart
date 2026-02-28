import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages application locale (language) preferences
/// 
/// This manager handles:
/// - Loading saved locale on app startup
/// - Switching between languages
/// - Persisting language preference
/// - Providing locale display names
class LocaleManager extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  final SharedPreferences _prefs;

  Locale? _locale;
  bool _isInitialized = false;

  LocaleManager(this._prefs) {
    _loadLocaleSync();
  }

  /// Get current locale
  Locale? get locale => _locale;

  /// Check if manager is initialized
  bool get isInitialized => _isInitialized;

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('vi'), // Vietnamese
  ];

  /// Load locale synchronously from SharedPreferences (getters are sync).
  /// Runs during construction before any listeners exist, so no notification needed.
  void _loadLocaleSync() {
    final String? localeCode = _prefs.getString(_localeKey);
    if (localeCode != null && localeCode.isNotEmpty) {
      final savedLocale = Locale(localeCode);
      if (supportedLocales.contains(savedLocale)) {
        _locale = savedLocale;
      }
    }
    _isInitialized = true;
  }

  /// Set locale and save to preferences
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      debugPrint('LocaleManager: Unsupported locale ${locale.languageCode}');
      return;
    }

    _locale = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
    
    debugPrint('LocaleManager: Locale changed to ${locale.languageCode}');
  }

  /// Clear locale (will use system default)
  Future<void> clearLocale() async {
    _locale = null;
    await _prefs.remove(_localeKey);
    notifyListeners();
    
    debugPrint('LocaleManager: Locale cleared, using system default');
  }

  /// Get locale name for display
  String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Tiếng Việt';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  /// Get current locale name
  String get currentLocaleName {
    if (_locale == null) {
      return 'System Default';
    }
    return getLocaleName(_locale!);
  }

  /// Check if a locale is currently selected
  bool isLocaleSelected(Locale locale) {
    return _locale == locale;
  }

  /// Get system locale if no locale is set
  Locale getEffectiveLocale(BuildContext context) {
    return _locale ?? Localizations.localeOf(context);
  }
}
