import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_code_controller.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';

class DeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DeviceController>(DeviceController());
    Get.lazyPut<QrCodeController>(() => QrCodeController());
  }
}
