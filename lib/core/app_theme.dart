import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF8C25F4);
  static const Color bgLight = Color(0xFFF7F5F8);
  static const Color bgDark = Color(0xFF191022);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color emerald600 = Color(0xFF059669);
  static const Color textMuted = Color(0xFF64748B);
  static const Color accentGold = Color(0xFFF59E0B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        surface: Colors.white,
        background: bgLight,
        onSurface: slate900,
      ),
      scaffoldBackgroundColor: bgLight,
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: slate900,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: slate900,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: slate500,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: primaryColor,
    );
  }
}