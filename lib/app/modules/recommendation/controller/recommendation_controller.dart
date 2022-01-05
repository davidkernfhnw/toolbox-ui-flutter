import 'dart:developer';

import 'package:geiger_toolbox/app/services/helpers/implementation/impl_user_service.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;
import 'package:get/get.dart' as getX;
import 'package:geiger_localstorage/geiger_localstorage.dart';

class RecommendationController extends getX.GetxController {
  //an instance of RecommendationController
  static RecommendationController instance() {
    return getX.Get.find();
  }

  final LocalStorageController _storageControllerInstance =
      LocalStorageController.instance;

  late final StorageController _storageController;
  late final UserService _userService;

  getX.Rx<dummy.ThreatScore> userThreatScore =
      dummy.ThreatScore(score: "", threat: dummy.Threat(threatId: "", name: ""))
          .obs;
  var userGeigerScore = "".obs;

//device score
  getX.Rx<dummy.ThreatScore> deviceThreatScore =
      dummy.ThreatScore(score: "", threat: dummy.Threat(threatId: "", name: ""))
          .obs;
  var deviceGeigerScore = "".obs;

//user recommendation
  getX.Rx<dummy.GeigerRecommendation> userGeigerRecommendations =
      dummy.GeigerRecommendation(
              recommendations: [], threat: dummy.Threat(name: ""))
          .obs;
//device recommendation
  getX.Rx<dummy.GeigerRecommendation> deviceGeigerRecommendations =
      dummy.GeigerRecommendation(
              recommendations: [], threat: dummy.Threat(name: ""))
          .obs;

  //retrieve arguments from Routes
  dummy.Threat t = getX.Get.arguments;
  _showUserThreat() async {
    log(getX.Get.arguments.name.toString());
    dummy.GeigerScoreThreats u = await _getUserThreatScore();
    userThreatScore.value = u.threatScores
        .where((dummy.ThreatScore element) =>
            element.threat.threatId == t.threatId)
        .toList()
        .first;
    userGeigerScore.value = u.geigerScore;
    log(userThreatScore.value.toString());
  }

  _showDeviceThreat() async {
    dummy.GeigerScoreThreats u = await _getDeviceThreatScore();
    deviceThreatScore.value = u.threatScores
        .where((dummy.ThreatScore element) => element.threat == t)
        .toList()
        .first;
    deviceGeigerScore.value = u.geigerScore;
    log(userThreatScore.value.toString());
  }

  Future<dummy.GeigerScoreThreats> _getUserThreatScore() async {
    String currentUserId = await _userService.getUserId;
    NodeValue? nodeValueG = await _storageController.getValue(
        ":Users:${currentUserId}:gi:data:GeigerScoreUser", "GEIGER_score");
    NodeValue? nodeValueT = await _storageController.getValue(
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
    String currentDeviceId = await _userService.getDeviceId;
    NodeValue? nodeValueG = await _storageController.getValue(
        ":Devices:${currentDeviceId}:gi:data:GeigerScoreDevice",
        "GEIGER_score");
    NodeValue? nodeValueT = await _storageController.getValue(
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
    Node _node = await _storageController.get(":Global:recommendations");

    for (String recId
        in await _node.getChildNodesCsv().then((value) => value.split(','))) {
      Node recNode =
          await _storageController.get(":Global:recommendations:$recId");
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
    log("rec ${gR.length}");
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

  //storageController
  Future<void> _init() async {
    _storageController = _storageControllerInstance.getStorageController;
    _userService = UserService(_storageController);
  }

  @override
  onInit() async {
    await _init();
    _showUserThreat();
    _showDeviceThreat();
    await _userRec();
    await _deviceRec();
    super.onInit();
  }

  @override
  onReady() async {
    //log(threatScore.value.threat.toString());
    super.onReady();
  }
}
