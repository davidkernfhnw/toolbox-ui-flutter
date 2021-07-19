import 'package:geiger_toolbox/controllers/compare_risk_controller.dart';
import 'package:get/get.dart';

class CompareRiskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompareRiskController());
  }
}
