import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/cloudReplication/cloud_replication_controller.dart';
import 'app/services/indicator/geiger_indicator_controller.dart';
import 'app/services/localNotification/local_notification.dart';
import 'app/services/localStorage/local_storage_controller.dart';
import 'app/translation/app_translation.dart';
import 'app/util/theme/custom_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialization();
  runApp(GeigerApp());
}

Future<void> _initialization() async {
  //initialize geigerApi for ui
  // Dynamically adding the function to handle the SCAN_COMPLETED event -> you can customize or move it somewhere if you want
  await Get.put(GeigerApiConnector()).initGeigerApi();
  //initialize localStorage for ui
  await Get.put(LocalStorageController());

  //initialize indicator
  await Get.put(GeigerIndicatorController());

  //initialize cloudReplicationController
  Get.lazyPut<CloudReplicationController>(() => CloudReplicationController());
  //cached data
  await GetStorage.init();

  //Local notification
  Get.lazyPut<LocalNotificationController>(() => LocalNotificationController());
}

class GeigerApp extends StatelessWidget {
  const GeigerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      getPages: Pages.pages,
      initialRoute: Routes.HOME_VIEW,
      translationsKeys: AppTranslation.translationsKeys,
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en'),
      theme: customThemeData(),
    );
  }
}
