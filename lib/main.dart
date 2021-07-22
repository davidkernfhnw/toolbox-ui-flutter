import 'package:flutter/material.dart';

import 'package:geiger_toolbox/routes/pages.dart';
import 'package:geiger_toolbox/routes/routes.dart';
import 'package:get/get.dart';

void main() {
  runApp(GeigerApp());
}

class GeigerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      initialRoute: Routes.SCAN_RISK,
      getPages: Pages.screens,
      theme: customThemeData(),
    );
  }
}

ThemeData customThemeData() {
  return ThemeData(
    primaryColor: Color(0xFFFFFFFF),
    primarySwatch: Colors.green,
    secondaryHeaderColor: Color(0xFF00B95D),
    textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 34.0, fontWeight: FontWeight.w500, fontFamily: 'Hind'),
      headline2: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, fontFamily: 'Nunito'),
      bodyText2: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          fontFamily: 'Nunito',
          color: Colors.black),
    ),
  );
}
