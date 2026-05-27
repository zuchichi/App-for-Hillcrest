import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF3C8D4C);
  static const Color background = Color(0xFFF3F4F6);
  static const Color searchFill = Color(0xFFEAE7F2);
  static const Color logoText = Color(0xFF88A888);

  static ThemeData get theme {
    return ThemeData(
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
      ),
      useMaterial3: true,
    );
  }
}
