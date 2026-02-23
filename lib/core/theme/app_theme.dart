import 'package:flutter/material.dart';
import 'app_color_scheme.dart';
import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = AppColorScheme.lightScheme;
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColorScheme.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorScheme.lightPrimary,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppColorScheme.lightOnPrimary,
        iconTheme: const IconThemeData(color: AppColorScheme.lightOnPrimary),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColorScheme.lightOnPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColorScheme.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColorScheme.lightBackground,
        selectedItemColor: AppColorScheme.lightPrimary,
        unselectedItemColor: AppColorScheme.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: AppTextTheme.textTheme.apply(
        bodyColor: AppColorScheme.lightTextArabic,
        displayColor: AppColorScheme.lightAccentGold,
      ),
      dividerColor: AppColorScheme.lightBorderGold,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: AppColorScheme.darkScheme,
      scaffoldBackgroundColor: AppColorScheme.scaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColorScheme.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColorScheme.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColorScheme.surface,
        selectedItemColor: AppColorScheme.secondary,
        unselectedItemColor: AppColorScheme.disabled,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: AppTextTheme.textTheme,
      dividerColor: AppColorScheme.divider,
    );
  }
}
