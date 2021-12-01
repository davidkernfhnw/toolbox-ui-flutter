import 'package:get/get.dart';

import '../controllers/security_defenders_controller.dart';

class SecurityDefendersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecurityDefendersController>(
      () => SecurityDefendersController(),
    );
  }
}
