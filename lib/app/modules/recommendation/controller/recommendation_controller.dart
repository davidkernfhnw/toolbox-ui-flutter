import 'dart:developer';

import 'package:geiger_toolbox/app/data/model/recommendations_models.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:get/get.dart';

class RecommendationController extends GetxController {
  //an instance of RecommendationController
  static RecommendationController to() {
    return Get.find();
  }

  //observable
  Rx<Threat> threat = Threat(null, null, null).obs;

  setThreat() {
    log(Get.arguments.name.toString());
    threat.value = Get.arguments;
  }

  @override
  onInit() {
    setThreat();
    super.onInit();
  }

  List<RecommendationModel> recommendations =
      RecommendationModel.recommendations().obs;
}
