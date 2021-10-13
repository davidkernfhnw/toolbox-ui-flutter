import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'custom_material_color.dart';

ThemeData customThemeData() {
  return ThemeData(
    primarySwatch: CustomMaterialColor.createMaterialColor(Colors.white),

    toggleableActiveColor: Colors.green,

    //customize styling for elevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
          backgroundColor: Colors.green, primary: Colors.white),
    ),

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
