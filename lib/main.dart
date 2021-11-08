import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/services/local_storage.dart';

import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/util/theme/custom_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// localStorage database
  await LocalStorage.initLocalStorage();
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
        initialRoute: Routes.TERMS_AND_CONDITIONS,
        getPages: Pages.pages,
        theme: customTheme);
  }
}
