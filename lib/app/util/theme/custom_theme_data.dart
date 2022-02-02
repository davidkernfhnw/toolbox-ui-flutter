import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_material_color.dart';

ThemeData customThemeData() {
  const String NUNITO_FONT = "Nunito";
  return ThemeData(
    primarySwatch: CustomMaterialColor.createMaterialColor(Colors.white),
    unselectedWidgetColor: Colors.green,
    toggleableActiveColor: Colors.green,

    //customize styling for elevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
          backgroundColor: Colors.green, primary: Colors.white),
    ),

    textTheme: TextTheme(
      headline1: Get.textTheme.headline1!.copyWith(
          fontSize: 34.0, fontWeight: FontWeight.w500, fontFamily: NUNITO_FONT),
      headline2: Get.textTheme.headline2!.copyWith(
          fontSize: 16.0, fontWeight: FontWeight.bold, fontFamily: NUNITO_FONT),
      bodyText2: Get.textTheme.bodyText2!.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontFamily: NUNITO_FONT),
    ),

    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder()
    }),
  );
}
