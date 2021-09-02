import 'package:geiger_toolbox/app/modules/compare/controller/compare_risk_controller.dart';
import 'package:get/get.dart';

class CompareRiskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompareRiskController());
  }
}
