import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_material_color.dart';

ThemeData customThemeData() {
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
        fontSize: 34.0,
        fontWeight: FontWeight.w500,
      ),
      headline2: Get.textTheme.headline2!.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: Get.textTheme.bodyText2!.copyWith(
          fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.black),
    ),

    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder()
    }),
  );
}
