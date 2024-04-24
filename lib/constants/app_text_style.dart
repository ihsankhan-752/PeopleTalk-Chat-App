import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:people_talk/constants/app_colors.dart';

class AppTextStyle {
  static TextStyle h1 = TextStyle(
    fontSize: 16,
    color: AppColors.primaryWhite,
    fontWeight: FontWeight.bold,
  );
  static TextStyle main = GoogleFonts.acme(
    fontSize: 16,
    color: AppColors.primaryWhite,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );
}
