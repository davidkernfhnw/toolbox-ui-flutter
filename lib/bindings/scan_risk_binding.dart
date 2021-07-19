import 'package:geiger_toolbox/controllers/scan_risk_controller.dart';
import 'package:get/get.dart';

class ScanRiskBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ScanRiskController());
  }
}
