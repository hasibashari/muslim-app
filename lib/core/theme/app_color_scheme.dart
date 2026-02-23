import 'package:flutter/material.dart';

class AppColorScheme {
  AppColorScheme._();

  // ══════════════════════════════════════════════════
  // ── Dark Theme Colors ──
  // ══════════════════════════════════════════════════

  // ── Brand colors (dark) ──
  static const Color primary = Color(0xFF1B5E20);
  static const Color secondary = Color(0xFF66BB6A);
  static const Color primaryContainer = Color(0xFF1B3A1F);
  static const Color secondaryContainer = Color(0xFF2E7D32);

  // ── Surface / Background (dark) ──
  static const Color surface = Color(0xFF121212);
  static const Color scaffoldBackground = Color(0xFF0A0A0A);
  static const Color cardBackground = Color(0xFF1E1E1E);

  // ── On-colors (dark) ──
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onSurface = Colors.white;

  // ── Neutral (dark) ──
  static const Color divider = Color(0xFF2A2A2A);
  static const Color disabled = Color(0xFF757575);
  static const Color hint = Color(0xFF9E9E9E);

  // ── Text tones (dark) ──
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFE0E0E0);
  static const Color textTertiary = Color(0xFFBDBDBD);
  static const Color textCaption = Color(0xFF9E9E9E);
  static const Color textLabel = Color(0xFF757575);

  // ── Accent palette for quick menu ──
  static const Color accentGreen = Color(0xFF43A047);
  static const Color accentBlue = Color(0xFF1E88E5);
  static const Color accentOrange = Color(0xFFFB8C00);
  static const Color accentRed = Color(0xFFE53935);
  static const Color accentPurple = Color(0xFF8E24AA);
  static const Color accentCyan = Color(0xFF00ACC1);

  // ══════════════════════════════════════════════════
  // ── Light Theme Colors ──
  // ══════════════════════════════════════════════════

  // ── Primary (Header / Brand) ──
  static const Color lightPrimary = Color(0xFF2E5D57);
  static const Color lightPrimaryVariant = Color(0xFF3F766E);

  // ── Accent (Ornaments & Verse Numbers) ──
  static const Color lightAccentGold = Color(0xFFC5B59B);
  static const Color lightBorderGold = Color(0xFFB9A789);

  // ── Background System ──
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Color(0xFFD9D4C7);
  static const Color lightDecorativeStrip = Color(0xFFE4DDCD);

  // ── Text System ──
  static const Color lightTextArabic = Colors.black;
  static const Color lightTextTranslation = Color(0xFF555555);
  static const Color lightTextSecondary = Color(0xFF8C8C8C);
  static const Color lightOnPrimary = Colors.white;

  /// Full light [ColorScheme] consumed by [ThemeData].
  static ColorScheme get lightScheme => const ColorScheme.light(
    primary: lightPrimary,
    secondary: lightAccentGold,
    surface: Color(0xFFFAF8EC),
    onPrimary: lightOnPrimary,
    onSecondary: lightTextArabic,
    onSurface: lightTextArabic,
    primaryContainer: lightPrimaryVariant,
    secondaryContainer: lightBorderGold,
    tertiary: lightAccentGold,
    onTertiary: lightTextArabic,
    tertiaryContainer: lightDecorativeStrip,
    surfaceContainerHighest: lightSurface,
    outline: lightBorderGold,
    outlineVariant: lightDecorativeStrip,
  );

  /// Full dark [ColorScheme] consumed by [ThemeData].
  static ColorScheme get darkScheme => const ColorScheme.dark(
    primary: primary,
    secondary: secondary,
    surface: surface,
    onPrimary: onPrimary,
    onSecondary: onSecondary,
    onSurface: onSurface,
    primaryContainer: primaryContainer,
    secondaryContainer: secondaryContainer,
  );
}
