import 'package:flutter/material.dart';

/// Teranga design: warm, premium interface (PRD §8).
class AppTheme {
  static const Color _seed = Color(0xFFC45C2C); // Warm terracotta / lion
  static const Color _background = Color(0xFFFDF8F5);
  static const Color _surface = Color(0xFFFFFBF7);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
      primary: const Color(0xFFB84A1A),
      surface: _surface,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(surface: _surface),
      scaffoldBackgroundColor: _background,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _surface,
        foregroundColor: Color(0xFF2C1810),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
