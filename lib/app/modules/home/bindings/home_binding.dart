import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:geiger_toolbox/app/modules/termsAndConditions/controllers/terms_and_conditions_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsAndConditionsController>(
        () => TermsAndConditionsController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
