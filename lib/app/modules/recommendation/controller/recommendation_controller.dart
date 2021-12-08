import 'dart:developer';

import 'package:geiger_toolbox/app/data/model/recommendations_models.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/data/model/threat_score.dart';
import 'package:get/get.dart';

class RecommendationController extends GetxController {
  //an instance of RecommendationController
  static RecommendationController to() {
    return Get.find();
  }

  //observable
  Rx<ThreatScore> threat = ThreatScore(score: '', threat: Threat(null, "")).obs;

  setThreat() {
    log(Get.arguments.score.toString());
    //retrieve arguments from Routes
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
