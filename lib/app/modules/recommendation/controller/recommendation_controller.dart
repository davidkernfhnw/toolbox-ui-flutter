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

  //******* start of instance **********
  final LocalStorageController _storageControllerInstance =
      LocalStorageController.instance;

  final GeigerIndicatorController _indicatorControllerInstance =
      GeigerIndicatorController.instance;

  //**** end of instance

  //**** late variables ******
  late final StorageController _storageController;
  late final UserService _userService;
  late GeigerIndicatorHelper _geigerIndicatorData;
  // *** end of late variables ****

  //**** observable variable ****
  var isLoading = false.obs;
  var userName = "".obs;
  var userGeigerScore = "0.0".obs;
  var deviceGeigerScore = "0.0".obs;
  //**** end of observable variable ***

  //*** observable object *****
  getX.Rx<ThreatScore> userThreatScore =
      ThreatScore(score: "0.0", threat: Threat(threatId: "", name: "")).obs;

  //device score
  getX.Rx<ThreatScore> deviceThreatScore =
      ThreatScore(score: "0.0", threat: Threat(threatId: "", name: "")).obs;

  //user recommendation
  getX.RxList<Recommendation> userGeigerRecommendations =
      <Recommendation>[].obs;
  //device recommendation
  getX.RxList<Recommendation> deviceGeigerRecommendations =
      <Recommendation>[].obs;

  //*** end observable  object *****

  //retrieve threat<Threat> from Routes when user pressed the improve button
  Threat threat = getX.Get.arguments;

  //************* start of private methods ***********************

  //show user threat score
  Future<void> _showUserThreat() async {
    //get userThreatScore
    GeigerScoreThreats geigerUserScore = await _getUserThreatScore();
    log("GeigerUserScore => $geigerUserScore");
    //geiger userScore
    userGeigerScore.value = geigerUserScore.geigerScore;

    //filter to get a userThreatScore by using threat<Threat>

    userThreatScore.value = geigerUserScore.threatScores.firstWhere(
        (ThreatScore value) => value.threat.threatId.contains(threat.threatId));
  }

  Future<void> _showDeviceThreat() async {
    GeigerScoreThreats geigerDeviceScore = await _getDeviceThreatScore();

    log("GeigerDeviceScore => $geigerDeviceScore");
    //geiger deviceScore
    deviceGeigerScore.value = geigerDeviceScore.geigerScore;

    //filter to get a deviceThreatScore by using threat<Threat>
    deviceThreatScore.value = geigerDeviceScore.threatScores.firstWhere(
        (ThreatScore element) =>
            element.threat.threatId.contains(threat.threatId));
  }

  //returns user of GeigerScoreThreats
  Future<GeigerScoreThreats> _getUserThreatScore() async {
    User? currentUser = await _userService.getUserInfo;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String path =
        ":Users:${currentUser!.userId}:$indicatorId:data:GeigerScoreUser";
    //get user geigerScoreThreats
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
    //get device geigerScoreThreats
    GeigerScoreThreats geigerScoreThreats =
        await _geigerIndicatorData.getGeigerScoreThreats(path: path);

    return geigerScoreThreats;
  }

  Future<List<Recommendation>> _getUserRecommendation() async {
    User? currentUser = await _userService.getUserInfo;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String userRecommendationPath =
        ":Users:${currentUser!.userId}:$indicatorId:data:recommendations";

    String geigerScoreUserPath =
        ":Users:${currentUser.userId}:$indicatorId:data:GeigerScoreUser";

    List<Recommendation> geigerScoreThreats =
        await _geigerIndicatorData.getGeigerRecommendationsLoung(
            recommendationPath: userRecommendationPath,
            threatId: threat.threatId,
            geigerScorePath: geigerScoreUserPath);

    //set observable variable
    userGeigerRecommendations.value = geigerScoreThreats;

    return geigerScoreThreats;
  }

  Future<List<Recommendation>> _getDeviceRecommendation() async {
    User? currentUser = await _userService.getUserInfo;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String deviceRecommendationpath =
        ":Devices:${currentUser!.deviceOwner!.deviceId}:$indicatorId:data:recommendations";

    String geigerScoreDevicePath =
        ":Devices:${currentUser.deviceOwner!.deviceId}:$indicatorId:data:GeigerScoreDevice";

    List<Recommendation> deviceRecommendation =
        await _geigerIndicatorData.getGeigerRecommendationsLoung(
            recommendationPath: deviceRecommendationpath,
            threatId: threat.threatId,
            geigerScorePath: geigerScoreDevicePath);
    //set observable variable
    deviceGeigerRecommendations.value = deviceRecommendation;
    log("Device Recommendation => $deviceGeigerRecommendations");
    return deviceRecommendation;
  }

  void _showUserName() async {
    User? currentUser = await _userService.getUserInfo;
    //set observable variable

    userName.value = currentUser!.userName ?? "";
  }

  Future<void> _implementRecommendation(
      {required String recommendationId, required String path}) async {
    String recommendationIds = "";
    String key = "implementedRecommendations";

    NodeValue? nodeValue = await _storageController.getValue(path, key);
    String? existImplRecom = nodeValue?.value;

    if (existImplRecom != "" && existImplRecom != null) {
      recommendationIds = "," + existImplRecom;
      log("£xisting => $recommendationIds");
    }
    String r = recommendationId + recommendationIds;

    nodeValue!.setValue("${r}");
    await _storageController.updateValue(path, nodeValue);

    isLoading.value = false;
    log("${await _storageController.dump(path)}");
  }

  void _setCheckBox(
      List<Recommendation> recommendations, Recommendation recommendation) {
    for (Recommendation r in recommendations) {
      log("recommendation ==> $r");
      if (r.recommendationId == recommendation.recommendationId) {
        log("Implemented value => ${recommendation.implemented}");
        //set checkbox to true
        r.implemented = true;
        log("Recommendation after set implemented => $r");
      }
    }
  }

  //init storageController, userService and geigerIndicatorData
  Future<void> _init() async {
    _storageController = _storageControllerInstance.getStorageController;
    _userService = UserService(_storageController);
    _geigerIndicatorData = GeigerIndicatorHelper(_storageController);
  }

  //***** end of private method ******

  //****** start of public method *****
  void implementRecommendation({required Recommendation recommendation}) async {
    // set isLoading true
    //has it take some millsec to complete
    isLoading.value = true;
    log("recommendations => $recommendation");
    String indicatorId = _indicatorControllerInstance.indicatorId;
    User? currentUser = await _userService.getUserInfo;
    String userPath =
        ":Users:${currentUser!.userId}:$indicatorId:data:GeigerScoreUser";
    String devicePath =
        ":Devices:${currentUser.deviceOwner!.deviceId}:$indicatorId:data:GeigerScoreDevice";

    if (recommendation.recommendationType.toLowerCase() == "users") {
      //implement user recommendation
      await _implementRecommendation(
          recommendationId: recommendation.recommendationId, path: userPath);

      // set user Recommendations
      _setCheckBox(userGeigerRecommendations, recommendation);
    } else {
      //set device recommendation
      await _implementRecommendation(
          recommendationId: recommendation.recommendationId, path: devicePath);
      //set device Recommendations
      _setCheckBox(deviceGeigerRecommendations, recommendation);
    }
    isLoading.value = false;
  }

  //*** end public method *****

  @override
  onInit() async {
    isLoading.value = true;
    await _init();
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
    super.onReady();
  }
}
