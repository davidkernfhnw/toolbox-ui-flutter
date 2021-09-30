import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/util/theme/custom_theme_data.dart';

void main() {
  runApp(GeigerApp());
}

class GeigerApp extends StatelessWidget {
  GeigerApp({Key? key}) : super(key: key);
  final ThemeData customTheme = customThemeData();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: true,
        navigatorKey: Get.key,
        initialRoute: Routes.HOME_PAGE,
        getPages: Pages.pages,
        theme: customTheme);
  }
}
