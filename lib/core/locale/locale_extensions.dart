import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Extension to easily access localized strings
extension LocalizationExtension on BuildContext {
  /// Get localized strings
  /// 
  /// Usage:
  /// ```dart
  /// Text(context.l10n.login)
  /// Text(context.l10n.save)
  /// ```
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  
  /// Get current locale
  Locale get currentLocale => Localizations.localeOf(this);
  
  /// Check if current locale is English
  bool get isEnglish => currentLocale.languageCode == 'en';
  
  /// Check if current locale is Vietnamese
  bool get isVietnamese => currentLocale.languageCode == 'vi';
}
