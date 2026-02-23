import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

class AppTextTheme {
  AppTextTheme._();

  static const TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.normal,
      color: AppColorScheme.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: AppColorScheme.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: AppColorScheme.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColorScheme.textPrimary,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: AppColorScheme.textSecondary),
    bodyMedium: TextStyle(fontSize: 14, color: AppColorScheme.textTertiary),
    bodySmall: TextStyle(fontSize: 12, color: AppColorScheme.textCaption),
    labelSmall: TextStyle(fontSize: 11, color: AppColorScheme.textLabel),
  );
}
