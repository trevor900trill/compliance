import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF26604E); // Nairobi Green
  static const Color accentColor = Color(0xFFFFC107); // Nairobi Gold
  static const Color textColor = Color(0xFF333333); // Dark Gray
  static const Color backgroundColor = Color(0xFFFFFFFF); // White

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.latoTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 16.0,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(color: primaryColor, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
    ),
    labelStyle: GoogleFonts.lato(
      color: Colors.grey[600],
      fontWeight: FontWeight.w500,
    ),
    hintStyle: GoogleFonts.lato(
      color: Colors.grey[400],
      fontWeight: FontWeight.w400,
    ),
  ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
