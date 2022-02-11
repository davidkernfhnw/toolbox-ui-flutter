import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../../settings/controllers/data_protection_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DataProtectionController>(
      () => DataProtectionController(),
    );
  }
}
