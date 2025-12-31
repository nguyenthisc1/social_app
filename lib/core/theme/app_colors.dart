import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9691FF);
  static const Color primaryDark = Color(0xFF4E47CC);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF6584);
  static const Color secondaryLight = Color(0xFFFF94AD);
  static const Color secondaryDark = Color(0xFFCC5169);

  // Accent Colors
  static const Color accent = Color(0xFF00D9A6);
  static const Color accentLight = Color(0xFF4DFFCD);
  static const Color accentDark = Color(0xFF00A67D);

  // Neutral Colors - Light Theme
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Neutral Colors - Dark Theme
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2A2A2A);

  // Text Colors - Light Theme
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textHint = Color(0xFF9E9E9E);

  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textDisabledDark = Color(0xFF6E6E6E);
  static const Color textHintDark = Color(0xFF8E8E8E);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // Social Media Colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color instagram = Color(0xFFE4405F);
  static const Color linkedin = Color(0xFF0A66C2);
  static const Color youtube = Color(0xFFFF0000);
  static const Color github = Color(0xFF181717);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6C63FF),
    Color(0xFF9691FF),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFFF6584),
    Color(0xFFFF94AD),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF00D9A6),
    Color(0xFF4DFFCD),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF1E1E1E),
    Color(0xFF2A2A2A),
  ];

  // Overlay Colors
  static Color overlay(double opacity) => Colors.black.withValues(alpha: opacity);
  static Color overlayLight(double opacity) => Colors.white.withValues(alpha: opacity);

  // Divider Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x3D000000);
}

