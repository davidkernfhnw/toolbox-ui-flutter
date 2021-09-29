import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/util/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData customThemeData() {
  return ThemeData(
    primaryColor: AppColors.white,
    primarySwatch: AppColors.green,
    secondaryHeaderColor: const Color(0xFF00395D),
    textTheme: TextTheme(
      headline1: GoogleFonts.hind().copyWith(
        fontSize: 34.0,
        fontWeight: FontWeight.w500,
      ),
      headline2: GoogleFonts.nunito().copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: GoogleFonts.nunito().copyWith(
          fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.black),
    ),
  );
}
