import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_scanner_controller.dart';
import 'package:get/get.dart';

class QrScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<QrScannerController>(QrScannerController());
  }
}
