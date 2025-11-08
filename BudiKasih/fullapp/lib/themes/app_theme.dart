import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
    ),
    // Use Inknut Antiqua from google_fonts as the app's default text theme.
    // This ensures all Material widgets use Inknut Antiqua without adding
    // the font as an asset. If you prefer to bundle the font instead,
    // see the alternative instructions in the README or comments.
    textTheme: GoogleFonts.inknutAntiquaTextTheme(),
    primaryTextTheme: GoogleFonts.inknutAntiquaTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}