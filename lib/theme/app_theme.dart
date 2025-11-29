import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primary = Color(0xFF00D9D9);
  static const Color background = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF222222);
  static const Color cardColor = Color(0xFF151515);
  static const Color muted = Color(0xFF9E9E9E);
  static const Color danger = Color(0xFFFF6B6B);

  static const double screenPadding = 16.0;
  static const EdgeInsets pagePadding = EdgeInsets.all(screenPadding);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    vertical: 14,
    horizontal: 16,
  );

  static ThemeData get darkTheme {
    final base = ThemeData.dark();

    return base.copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: primary,
        background: background,
        surface: surface,
        onPrimary: Colors.black,
        onSurface: Colors.white,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF141414),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // ⭐ FIXED: CardTheme → CardThemeData
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: primary.withOpacity(0.9)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),

      // Text fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF121212),
        contentPadding: inputPadding,
        hintStyle: TextStyle(color: muted),
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: danger),
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.black,
      ),

      // Text styles
      textTheme: base.textTheme
          .apply(bodyColor: Colors.white, displayColor: Colors.white)
          .copyWith(
            titleLarge: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: const TextStyle(fontSize: 14, color: Colors.white),
            bodyMedium: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
    );
  }

  // Helper for text fields
  static InputDecoration inputDecoration({
    required String label,
    String? hint,
    Widget? prefix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefix == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: prefix,
            ),
    );
  }

  static const SizedBox vSpace8 = SizedBox(height: 8);
  static const SizedBox vSpace12 = SizedBox(height: 12);
  static const SizedBox vSpace16 = SizedBox(height: 16);
}
