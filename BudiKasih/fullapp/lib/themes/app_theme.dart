import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryBlue,

    textTheme: GoogleFonts.poppinsTextTheme(),

    fontFamily: GoogleFonts.poppins().fontFamily,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: GoogleFonts.poppins(
        color: Colors.grey[500],
        fontSize: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      contentTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}