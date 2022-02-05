import 'package:geiger_toolbox/app/modules/settings/controllers/data_controller.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/data_protection_controller.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
    Get.lazyPut<DataProtectionController>(
      () => DataProtectionController(),
    );
    Get.lazyPut<DataController>(
      () => DataController(),
    );
  }
}
