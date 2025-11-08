import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Keep the family name for reference, but prefer using GoogleFonts
  // implementations below so the font is loaded at runtime.
  static const String fontFamily = 'InknutAntiqua';

  static final TextStyle heading = GoogleFonts.inknutAntiqua(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.darkBlue,
  );

  static final TextStyle body = GoogleFonts.inknutAntiqua(
    fontSize: 14,
    color: Colors.black87,
  );

  static final TextStyle titleWhite = GoogleFonts.inknutAntiqua(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}