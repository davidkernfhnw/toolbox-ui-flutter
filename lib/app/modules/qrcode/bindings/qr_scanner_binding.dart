import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_code_controller.dart';
import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_scanner_controller.dart';
import 'package:get/get.dart';

class QrScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrScannerController>(() => QrScannerController());
  }
}
