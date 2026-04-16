import 'package:flutter/material.dart';

class AppThemes {
  // Medical Branding Colors [cite: 2026-02-23]
  static const Color primaryBlue = Color(0xFF003d80); // Professional Deep Blue
  static const Color accentTeal = Color(0xFF00796B);
  static const Color backgroundLight = Color(0xFFF8F9FA);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Android 15/16 Ready
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: accentTeal,
    ),

    // --- AppBar Theme ---
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // --- Card Theme (FIXED: Uses CardThemeData for Compatibility) --- [cite: 2026-02-21]
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // --- Bottom Navigation Bar Theme ---
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // --- Text Theme ---
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryBlue),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
    ),

    // --- Elevated Button Theme ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}