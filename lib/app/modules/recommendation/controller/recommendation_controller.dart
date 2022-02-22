import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/model/recommendation.dart';
import 'package:geiger_toolbox/app/model/threat.dart';
import 'package:geiger_toolbox/app/model/threat_score.dart';
import 'package:geiger_toolbox/app/model/user.dart';
import 'package:geiger_toolbox/app/services/indicator/geiger_indicator_controller.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_data_service.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:get/get.dart' as getX;

import '../../home/controllers/home_controller.dart';

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

  final HomeController _homeControllerInstance = HomeController.instance;

  //**** end of instance

  //**** late variables ******
  late final StorageController _storageController;
  late final GeigerUserService _userService;
  late GeigerDataService _geigerDataService;
  //late GeigerIndicatorService _geigerIndicatorHelper;

  // *** end of late variables ****

  //**** observable variable ****
  var isLoading = false.obs;
  var userName = "".obs;
  var deviceName = "".obs;
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
  Future<void> _showUserThreatScore() async {
    //get userThreatScore
    GeigerScoreThreats geigerUserScore = await _getUserThreatScore();
    //GeigerScoreThreats geigerUserScore = _getUserCachedData();
    log("GeigerUserScore => $geigerUserScore");
    //geiger userScore
    userGeigerScore.value = geigerUserScore.geigerScore;

    //filter to get a userThreatScore by using threat<Threat>

    userThreatScore.value = geigerUserScore.threatScores.firstWhere(
        (ThreatScore value) => value.threat.threatId.contains(threat.threatId));
  }

  Future<void> _showDeviceThreatScore() async {
    GeigerScoreThreats geigerDeviceScore = await _getDeviceThreatScore();
    //GeigerScoreThreats geigerDeviceScore = _getDeviceCachedData();
    log("GeigerDeviceScore => $geigerDeviceScore");
    //geiger deviceScore
    deviceGeigerScore.value = geigerDeviceScore.geigerScore;

    //filter to get a deviceThreatScore by using threat<Threat>
    deviceThreatScore.value = geigerDeviceScore.threatScores.firstWhere(
        (ThreatScore element) =>
            element.threat.threatId.contains(threat.threatId));
  }

  //returns user GeigerScoreThreats
  Future<GeigerScoreThreats> _getUserThreatScore() async {
    String path = _homeControllerInstance.getUserScorePath;
    //get user geigerScoreThreats
    GeigerScoreThreats geigerScoreThreats =
        await _geigerDataService.getGeigerScoreThreats(path: path);

    return geigerScoreThreats;
  }

  //returns device of GeigerScoreThreats
  Future<GeigerScoreThreats> _getDeviceThreatScore() async {
    String path = _homeControllerInstance.getDeviceScorePath;
    //get device geigerScoreThreats
    GeigerScoreThreats geigerScoreThreats =
        await _geigerDataService.getGeigerScoreThreats(path: path);

    return geigerScoreThreats;
  }

  void _getFilteredUserRecommendation() async {
    User? currentUser = await _userService.getUserInfo;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    List<Recommendation> globalDeviceReco =
        _homeControllerInstance.userGlobalRecommendations;
    //path to store recommendation Id
    String geigerScoreUserPath =
        ":Users:${currentUser!.userId}:$indicatorId:data:GeigerScoreUser";
    //path to get filtered user recommendation by geiger_indicator
    String userRecommendationPath =
        ":Users:${currentUser.userId}:$indicatorId:data:recommendations";
    List<Recommendation> filterReco =
        await _geigerDataService.getFilteredRecommendations(
            gRecommendations: globalDeviceReco,
            recommendationPath: userRecommendationPath,
            threatId: threat.threatId,
            geigerScorePath: geigerScoreUserPath);
    userGeigerRecommendations.value = filterReco;
    log("User Recommendation Screen ==> $userGeigerRecommendations");
  }

  void _getFilteredDeviceRecommendation() async {
    User? currentUser = await _userService.getUserInfo;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    List<Recommendation> globalDeviceReco =
        _homeControllerInstance.deviceGlobalRecommendations;
    //path to store recommendation Id
    String geigerScoreDevicePath =
        ":Devices:${currentUser!.deviceOwner!.deviceId}:$indicatorId:data:GeigerScoreDevice";
    //path to get filtered device recommendation by geiger_indicator
    String deviceRecommendationPath =
        ":Devices:${currentUser.deviceOwner!.deviceId}:$indicatorId:data:recommendations";
    List<Recommendation> filterReco =
        await _geigerDataService.getFilteredRecommendations(
            gRecommendations: globalDeviceReco,
            recommendationPath: deviceRecommendationPath,
            threatId: threat.threatId,
            geigerScorePath: geigerScoreDevicePath);
    deviceGeigerRecommendations.value = filterReco;
  }

  void _showName() async {
    User? currentUser = await _userService.getUserInfo;
    //set observable variable
    userName.value = currentUser!.userName ?? "";
    deviceName.value = currentUser.deviceOwner!.name ?? "";
  }

  Future<void> _implementRecommendation(
      {required String recommendationId, required String path}) async {
    isLoading.value = true;
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
    log("Current Implemented Recommendation${await _storageController.dump(path)}");
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
    _userService = GeigerUserService(_storageController);
    _geigerDataService = GeigerDataService(_storageController);

    // _geigerIndicatorHelper = GeigerIndicatorService(_storageController);
  }

  //***** end of private method ******

  //****** start of public method *****
  Future<bool> implementRecommendation(
      {required Recommendation recommendation}) async {
    // set isLoading true
    //has it take some millsec to complete
    isLoading.value = true;
    try {
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
            recommendationId: recommendation.recommendationId,
            path: devicePath);
        //set device Recommendations
        _setCheckBox(deviceGeigerRecommendations, recommendation);
      }
      isLoading.value = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  //*** end public method ****

  @override
  onInit() async {
    await _init();
    isLoading.value = true;
    _showName();
    _showUserThreatScore();
    _getFilteredUserRecommendation();

    isLoading.value = false;
    super.onInit();
  }

  @override
  onReady() async {
    isLoading.value = true;
    _showDeviceThreatScore();
    _getFilteredDeviceRecommendation();
    isLoading.value = false;
    super.onReady();
  }
}
