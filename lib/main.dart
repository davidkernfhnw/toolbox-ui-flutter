import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/modules/termsAndConditions/controllers/terms_and_conditions_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
//import 'app/services/local_storage.dart';
import 'app/services/local_storage.dart';
import 'app/translation/app_translation.dart';
import 'app/util/theme/custom_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize localStorage
  await Get.put(LocalStorageController()).initLocalStorage();
  //await Get.put(TermsAndConditionsController().previouslyAgreed());
  runApp(GeigerApp());
}

class GeigerApp extends StatelessWidget {
  const GeigerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: true,
        getPages: Pages.pages,
        initialRoute: Routes.TERMS_AND_CONDITIONS_VIEW,
        translationsKeys: AppTranslation.translationsKeys,
        locale: Get.deviceLocale,
        fallbackLocale: Locale('en'),
        theme: customThemeData());
  }
}

// class SplashView extends StatelessWidget {
//   const SplashView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     //bool lightMode =
//     MediaQuery.of(context).platformBrightness == Brightness.light;
//     return Scaffold(
//       // backgroundColor:
//       // lightMode ? const Color(0xffe1f5fe) : const Color(0xff042a49),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage('assets/images/Geiger_Logo.png'),
//                   fit: BoxFit.fitWidth),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Init {
//   Init._();
//   static final instance = Init._();
//
//   Future initialize() async {}
// }
