import 'dart:developer';

import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';
import 'package:get/get.dart';

class RecommendationBinding extends Bindings {
  @override
  void dependencies() {
    //only called when someone use Get.find<RecommendationController>()
    Get.lazyPut(() => RecommendationController());
  }
}
