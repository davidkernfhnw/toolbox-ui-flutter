import 'package:geiger_toolbox/app/services/cloudReplication/cloud_replication_controller.dart';
import 'package:get/get.dart';

import '../controllers/terms_and_conditions_controller.dart';

class TermsAndConditionsBinding extends Bindings {
  @override
  void dependencies() {
    //Get.put(LocalStorageController());
    Get.put<TermsAndConditionsController>(TermsAndConditionsController());
  }
}
