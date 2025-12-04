import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF00D9D9);
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF151515);
  static const Color muted = Color(0xFF9E9E9E);
  static const Color danger = Color(0xFFFF6B6B);

  static const double screenPadding = 20.0;
  static const EdgeInsets pagePadding = EdgeInsets.all(screenPadding);

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      // stable ColorScheme
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primary,
        surface: surface,
        onPrimary: Colors.black,
        onSurface: Colors.white,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // cardColor keeps card appearance consistent without setting a CardTheme instance
      cardColor: surface,

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: primary.withOpacity(0.9)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0B0B0B),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        hintStyle: TextStyle(color: muted),
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary.withOpacity(0.9), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: danger),
        ),
      ),

      // Text theme tweaks
      textTheme: base.textTheme
          .apply(bodyColor: Colors.white, displayColor: Colors.white)
          .copyWith(
            titleLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            bodyLarge: const TextStyle(fontSize: 14, color: Colors.white),
            bodyMedium: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
    );
  }
}