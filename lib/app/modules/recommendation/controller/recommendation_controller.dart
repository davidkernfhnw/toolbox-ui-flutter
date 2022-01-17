import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/data/model/recommendation.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/data/model/threat_score.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_toolbox/app/services/indicator/geiger_indicator_controller.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_indicator_data.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/impl_user_service.dart';
import 'package:get/get.dart' as getX;

class RecommendationController extends getX.GetxController {
  //an instance of RecommendationController
  static RecommendationController instance() {
    return getX.Get.find();
  }

  final LocalStorageController _storageControllerInstance =
      LocalStorageController.instance;

  final GeigerIndicatorController _indicatorControllerInstance =
      GeigerIndicatorController.instance;

  late final StorageController _storageController;
  late final UserService _userService;
  late GeigerIndicatorData _geigerIndicatorData;

  var isLoading = false.obs;
  var userName = "CurrentUser".obs;

  getX.Rx<ThreatScore> userThreatScore =
      ThreatScore(score: "", threat: Threat(threatId: "", name: "")).obs;
  var userGeigerScore = "0.0".obs;

//device score
  getX.Rx<ThreatScore> deviceThreatScore =
      ThreatScore(score: "", threat: Threat(threatId: "", name: "")).obs;
  var deviceGeigerScore = "0.0".obs;

//user recommendation
  getX.RxList<Recommendation> userGeigerRecommendations =
      <Recommendation>[].obs;
//device recommendation
  getX.RxList<Recommendation> deviceGeigerRecommendations =
      <Recommendation>[].obs;

  //retrieve arguments from Routes
  Threat argument = getX.Get.arguments;

  Future<void> _showUserThreat() async {
    log(getX.Get.arguments.name.toString());
    GeigerScoreThreats geigerUserScore = await _getUserThreatScore();

    log(userThreatScore.value.toString());
    userGeigerScore.value = geigerUserScore.geigerScore;

    //filter to get a single Threat
    log("GeigerUserScore => $geigerUserScore");
    userThreatScore.value = geigerUserScore.threatScores.firstWhere(
        (ThreatScore element) =>
            element.threat.threatId.contains(argument.threatId));
  }

  Future<void> _showDeviceThreat() async {
    GeigerScoreThreats geigerDeviceScore = await _getDeviceThreatScore();

    log("GeigerDeviceScore => $geigerDeviceScore");
    //filter to get single threat
    deviceThreatScore.value = geigerDeviceScore.threatScores.firstWhere(
        (ThreatScore element) =>
            element.threat.threatId.contains(argument.threatId));
    deviceGeigerScore.value = geigerDeviceScore.geigerScore;
    log(userThreatScore.value.toString());
  }

  //returns user of GeigerScoreThreats
  Future<GeigerScoreThreats> _getUserThreatScore() async {
    User? currentUser = await _userService.getUserInfo;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String path =
        ":Users:${currentUser!.userId}:$indicatorId:data:GeigerScoreUser";
    GeigerScoreThreats geigerScoreThreats =
        await _geigerIndicatorData.getGeigerScoreThreats(path: path);

    return geigerScoreThreats;
  }

  //returns device of GeigerScoreThreats
  Future<GeigerScoreThreats> _getDeviceThreatScore() async {
    User? currentUser = await _userService.getUserInfo;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String path =
        ":Devices:${currentUser!.deviceOwner!.deviceId}:$indicatorId:data:GeigerScoreDevice";
    GeigerScoreThreats geigerScoreThreats =
        await _geigerIndicatorData.getGeigerScoreThreats(path: path);

    return geigerScoreThreats;
  }

  Future<List<Recommendation>> _getUserRecommendation() async {
    User? currentUser = await _userService.getUserInfo;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String path =
        ":Users:${currentUser!.userId}:$indicatorId:data:recommendations";
    List<Recommendation> geigerScoreThreats = await _geigerIndicatorData
        .getGeigerRecommendations(path: path, threatId: argument.threatId);
    userGeigerRecommendations.value = geigerScoreThreats;
    return geigerScoreThreats;
  }

  Future<List<Recommendation>> _getDeviceRecommendation() async {
    User? currentUser = await _userService.getUserInfo;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String path =
        ":Devices:${currentUser!.deviceOwner!.deviceId}:$indicatorId:data:recommendations";
    List<Recommendation> deviceRecommendation = await _geigerIndicatorData
        .getGeigerRecommendations(path: path, threatId: argument.threatId);
    deviceGeigerRecommendations.value = deviceRecommendation;
    log("Device Recommendation => $deviceGeigerRecommendations");
    return deviceRecommendation;
  }

  void _showUserName() async {
    User? currentUser = await _userService.getUserInfo;
    userName.value = currentUser!.userName!;
  }

  void _implementRecommendation(
      String recommendationId, String recommendationType) async {
    List<String> recommendationIds = [];

    String indicatorId = _indicatorControllerInstance.indicatorId;
    User? currentUser = await _userService.getUserInfo;
    String key = "implementedRecommendations";
    if (recommendationType.toLowerCase() == "user") {
      String userPath =
          ":Users:${currentUser!.userId}:$indicatorId:data:GeigerScoreUser";

      NodeValue? nodeValue = await _storageController.getValue(userPath, key);
      String? existImplRecom = nodeValue?.value;
      if (existImplRecom != null) {
        List<String> r = existImplRecom.split(",");
        recommendationIds.addAll(r);
      }
      recommendationIds.add(recommendationId);
      nodeValue!.setValue(recommendationIds.toString());
      _storageController.updateValue(userPath, nodeValue);
    } else {
      String devicePath =
          ":Devices:${currentUser!.deviceOwner!.deviceId}:$indicatorId:data:GeigerScoreDevice";
      recommendationIds.add(recommendationId);
      NodeValue? nodeValue = await _storageController.getValue(devicePath, key);
      String? existImplRecom = nodeValue?.value;
      if (existImplRecom != null) {
        List<String> r = existImplRecom.split(",");
        recommendationIds.addAll(r);
      }
      recommendationIds.add(recommendationId);
      nodeValue!.setValue(recommendationIds.toString());
      _storageController.updateValue(devicePath, nodeValue);
    }
  }

  //storageController
  Future<void> _init() async {
    _storageController = _storageControllerInstance.getStorageController;
    _userService = UserService(_storageController);
    _geigerIndicatorData = GeigerIndicatorData(_storageController);
  }

  @override
  onInit() async {
    isLoading.value = true;
    await _init();
    //await Future.delayed(Duration(seconds: 1));
    _showUserName();
    await _showUserThreat();
    await _showDeviceThreat();
    await _getUserRecommendation();
    await _getDeviceRecommendation();

    isLoading.value = false;
    super.onInit();
  }

  @override
  onReady() async {
    //log(threatScore.value.threat.toString());
    super.onReady();
  }
}
