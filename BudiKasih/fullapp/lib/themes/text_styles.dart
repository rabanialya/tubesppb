import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static const String fontFamily = 'Poppins';

  static final TextStyle heading = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.darkBlue,
  );

  static final TextStyle body = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.black87,
  );

  static final TextStyle titleWhite = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}