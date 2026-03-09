import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgTop = Color(0xFF0F1028);
  static const Color bgBottom = Color(0xFF1D1145);
  static const Color appBar = Color(0xFF0B0D24);
  static const Color panel = Color(0x141FFFFFF);

  static const Color neonCyan = Colors.cyanAccent;
  static const Color neonPink = Colors.pinkAccent;
  static const Color neonPurple = Colors.deepPurpleAccent;

  static ThemeData buildTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Arial',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgBottom,
      colorScheme: ColorScheme.fromSeed(
        seedColor: neonCyan,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: appBar,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.08),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static BoxDecoration neonPageGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [bgTop, bgBottom],
      ),
    );
  }

  static BoxDecoration neonPanel({
    Color borderColor = neonCyan,
    double borderWidth = 1.4,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: borderColor.withValues(alpha: 0.22),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
