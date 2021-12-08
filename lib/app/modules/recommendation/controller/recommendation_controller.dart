import 'dart:developer';

import 'package:geiger_toolbox/app/data/model/recommendations_models.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/data/model/threat_score.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;
import 'package:get/get.dart';

class RecommendationController extends GetxController {
  //an instance of RecommendationController
  static RecommendationController to() {
    return Get.find();
  }

  //observable
  Rx<dummy.ThreatScore> threat = dummy.ThreatScore(
          score: '', threat: dummy.Threat(threatId: null, name: ""))
      .obs;

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
