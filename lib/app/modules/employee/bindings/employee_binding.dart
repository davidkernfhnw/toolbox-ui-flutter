import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_code_controller.dart';
import 'package:get/get.dart';

import '../controllers/employee_controller.dart';

class EmployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeController>(
      () => EmployeeController(),
    );
    Get.lazyPut<QrCodeController>(() => QrCodeController());
  }
}
