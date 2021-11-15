import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/termsAndConditions/controllers/terms_and_conditions_controller.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/util/theme/custom_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// localStorage database
  //await LocalStorage.initLocalStorage();
  runApp(GeigerApp());
}

class GeigerApp extends StatelessWidget {
  const GeigerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: SplashView());
        } else {
          return GetMaterialApp(
              debugShowCheckedModeBanner: true,
              getPages: Pages.pages,
              initialRoute: Routes.TOOLS_VIEW,
              theme: customThemeData());
        }
      },
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //bool lightMode =
    MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      // backgroundColor:
      // lightMode ? const Color(0xffe1f5fe) : const Color(0xff042a49),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/Geiger_Logo.png'),
                  fit: BoxFit.fitWidth),
            ),
          ),
        ),
      ),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Get.put(TermsAndConditionsController().previouslyAgreed());
  }
}
