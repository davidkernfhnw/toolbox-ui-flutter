import 'dart:convert';
import 'dart:developer';

import 'package:geiger_toolbox/app/data/model/recommendations_models.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/data/model/threat_score.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;
import 'package:geiger_toolbox/app/services/dummy_storage_controller.dart';
import 'package:geiger_toolbox/app/services/ui_storage_controller.dart';
import 'package:get/get.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart' as geiger;

class RecommendationController extends GetxController {
  //an instance of RecommendationController
  static RecommendationController to() {
    return Get.find();
  }

  late final geiger.StorageController storageControllerUi;
  final UiStorageController _uiStorageControllerInstance =
      UiStorageController.instance;

  //observable
  //user score
  Rx<dummy.ThreatScore> userThreatScore =
      dummy.ThreatScore(score: "", threat: dummy.Threat(threatId: "", name: ""))
          .obs;
  var userGeigerScore = "".obs;

//device score
  Rx<dummy.ThreatScore> deviceThreatScore =
      dummy.ThreatScore(score: "", threat: dummy.Threat(threatId: "", name: ""))
          .obs;
  var deviceGeigerScore = "".obs;

//user recommendation
  Rx<dummy.GeigerRecommendation> userGeigerRecommendations =
      dummy.GeigerRecommendation(
              recommendations: [], threat: dummy.Threat(name: ""))
          .obs;
//device recommendation
  Rx<dummy.GeigerRecommendation> deviceGeigerRecommendations =
      dummy.GeigerRecommendation(
              recommendations: [], threat: dummy.Threat(name: ""))
          .obs;

  //retrieve arguments from Routes
  dummy.Threat t = Get.arguments;
  showUserThreat() async {
    log(Get.arguments.name.toString());
    dummy.GeigerScoreThreats u = await _getUserThreatScore();
    userThreatScore.value = u.threatScores
        .where((dummy.ThreatScore element) =>
            element.threat.threatId == t.threatId)
        .toList()
        .first;
    userGeigerScore.value = u.geigerScore;
    log(userThreatScore.value.toString());
  }

  showDeviceThreat() async {
    dummy.GeigerScoreThreats u = await _getDeviceThreatScore();
    deviceThreatScore.value = u.threatScores
        .where((dummy.ThreatScore element) => element.threat == t)
        .toList()
        .first;
    deviceGeigerScore.value = u.geigerScore;
    log(userThreatScore.value.toString());
  }

  Future<String> _getUserId() async {
    geiger.NodeValue? nodeValue =
        await storageControllerUi.getValue(":Local", "currentUser");
    return nodeValue!.value;
  }

  Future<String> _getDeviceId() async {
    geiger.NodeValue? nodeValue =
        await storageControllerUi.getValue(":Local", "currentDevice");
    return nodeValue!.value;
  }

  Future<dummy.GeigerScoreThreats> _getUserThreatScore() async {
    String currentUserId = await _getUserId();
    geiger.NodeValue? nodeValueG = await storageControllerUi.getValue(
        ":Users:${currentUserId}:gi:data:GeigerScoreUser", "GEIGER_score");
    geiger.NodeValue? nodeValueT = await storageControllerUi.getValue(
        ":Users:${currentUserId}:gi:data:GeigerScoreAggregate",
        "threats_score");
    List<dummy.ThreatScore> t =
        dummy.ThreatScore.convertFromJson(nodeValueT!.value);

    dummy.GeigerScoreThreats u = dummy.GeigerScoreThreats(
        threatScores: t, geigerScore: nodeValueG!.value);
    log("User score info: $u");
    return u;
  }

  Future<dummy.GeigerScoreThreats> _getDeviceThreatScore() async {
    String currentDeviceId = await _getDeviceId();
    geiger.NodeValue? nodeValueG = await storageControllerUi.getValue(
        ":Devices:${currentDeviceId}:gi:data:GeigerScoreDevice",
        "GEIGER_score");
    geiger.NodeValue? nodeValueT = await storageControllerUi.getValue(
        ":Devices:${currentDeviceId}:gi:data:GeigerScoreDevice",
        "threats_score");
    List<dummy.ThreatScore> t =
        dummy.ThreatScore.convertFromJson(nodeValueT!.value);

    dummy.GeigerScoreThreats u = dummy.GeigerScoreThreats(
        threatScores: t, geigerScore: nodeValueG!.value);
    log("Device score info: $u");
    return u;
  }

  Future<List<dummy.GeigerRecommendation>> get _getRecommendation async {
    List<dummy.Recommendations> r = [];
    List<dummy.GeigerRecommendation> gR = [];
    geiger.Node _node =
        await storageControllerUi.get(":Global:recommendations");

    for (String recId
        in await _node.getChildNodesCsv().then((value) => value.split(','))) {
      geiger.Node recNode =
          await storageControllerUi.get(":Global:recommendations:$recId");
      //log(recNode.toString());
      String json = await recNode
          .getValue("relatedThreat")
          .then((value) => value!.getValue("en")!);

      List<dummy.Threat> threats = dummy.Threat.convertFromJson(json);
      r.add(dummy.Recommendations(
        recommendationId: recId,
        recommendationType: await recNode
            .getValue("recommendationType")
            .then((value) => value!.getValue("en")!),
        description: dummy.DescriptionShortLong(
            shortDescription: await recNode
                .getValue("short")
                .then((value) => value!.getValue("en")!),
            longDescription: await recNode
                .getValue("long")
                .then((value) => value!.getValue("en")!)),
      ));
      for (dummy.Threat threat in threats) {
        gR.add(dummy.GeigerRecommendation(threat: threat, recommendations: r));
      }
    }
    print("rec ${gR.length}");
    return gR;
  }

  Future<List<dummy.Recommendations>> _userRec() async {
    List<dummy.GeigerRecommendation> r = await _getRecommendation;

    List<dummy.Recommendations> ur = r
        .where((element) => element.threat.threatId == t.threatId)
        .map((e) => e.recommendations
            .where((element) => element.recommendationType == "user")
            .toList())
        .toList()
        .first;
    log("filtered UserRecommendation: ${ur}");
    userGeigerRecommendations.value.recommendations = ur;
    return ur;
  }

  Future<List<dummy.Recommendations>> _deviceRec() async {
    List<dummy.GeigerRecommendation> r = await _getRecommendation;

    List<dummy.Recommendations> ur = r
        .where((element) => element.threat.threatId == t.threatId)
        .map((e) => e.recommendations
            .where((element) => element.recommendationType == "device")
            .toList())
        .toList()
        .first;
    log("filtered Device recommendation: ${ur}");
    deviceGeigerRecommendations.value.recommendations = ur;
    return ur;
  }

  // showUserReco() async {
  //   userR.value = await _userRec();
  // }

  //storageController
  Future<void> _init() async {
    storageControllerUi = _uiStorageControllerInstance.getUiController;
  }

  @override
  onInit() async {
    super.onInit();
    await _init();
    showUserThreat();
    showDeviceThreat();
  }

  @override
  onReady() async {
    super.onReady();
    await _userRec();
    await _deviceRec();
    //log(threatScore.value.threat.toString());
  }
}
