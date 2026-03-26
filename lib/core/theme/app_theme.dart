import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFFD4AF37); // Gold
  static const Color backgroundColor = Color(0xFF121212); // Deep Dark
  static const Color surfaceColor = Color(0xFF1E1E1E); // Elevated Dark
  static const Color errorColor = Color(0xFFE53935); // Red
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color textPrimaryColor = Color(0xFFFFFFFF);
  static const Color textSecondaryColor = Color(0xFFAAAAAA);

  // Status Colors
  static const Color availableColor = Color(0xFF4CAF50);
  static const Color bookedColor = Color(0xFF424242);
  static const Color selectedColor = primaryColor;

  // Spacing (8px grid system)
  static const double spacing8 = 8.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.cairo(color: textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 32),
        headlineMedium: GoogleFonts.cairo(color: textPrimaryColor, fontWeight: FontWeight.w700, fontSize: 24),
        titleMedium: GoogleFonts.cairo(color: textPrimaryColor, fontWeight: FontWeight.w600, fontSize: 18),
        bodyLarge: GoogleFonts.cairo(color: textPrimaryColor, fontSize: 16),
        bodyMedium: GoogleFonts.cairo(color: textSecondaryColor, fontSize: 14),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        prefixIconColor: textSecondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        hintStyle: GoogleFonts.cairo(color: textSecondaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // matching the input
          ),
          textStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
          elevation: 2,
        ),
      ),
    );
  }
}
