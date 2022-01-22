import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/modules/termsAndConditions/controllers/terms_and_conditions_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/cloudReplication/cloud_replication_controller.dart';
import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
import 'package:geiger_toolbox/app/services/indicator/geiger_indicator_controller.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_indicator_service.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_utility_service.dart';
import 'package:get/get.dart' as getX;
import 'package:get_storage/get_storage.dart';

class HomeController extends getX.GetxController {
  //an instance of HomeController
  static HomeController get instance => getX.Get.find();

  //******* start of instance **********

  final LocalStorageController _localStorageInstance =
      LocalStorageController.instance;

  final TermsAndConditionsController _termsAndConditionsController =
      TermsAndConditionsController.instance;

  final CloudReplicationController _cloudReplicationInstance =
      CloudReplicationController.instance;

  final GeigerIndicatorController _indicatorControllerInstance =
      GeigerIndicatorController.instance;
  final GeigerApiConnector geigerApiInstance = GeigerApiConnector.instance;

  //**** end of instance

  //**** late variables ******
  late final StorageController _storageController;
  late final GeigerUserService _userService;
  late final GeigerUtilityService _geigerUtilityData;
  late final GeigerIndicatorService _geigerIndicatorHelper;
  // *** end of late variables ****

  //**** observable variable ****
  var isScanning = false.obs;
  var isLoadingServices = false.obs;
  var message = "".obs;
  var isScanRequired = false.obs;
  var grantPermission = false.obs;
  var isScanCompleted = "".obs;
  var isStorageUpdated = "".obs;
  //**** end of observable variable ***

  //*** observable object *****
  // aggregate threatScore
  getX.Rx<GeigerScoreThreats> aggThreatsScore =
      GeigerScoreThreats(threatScores: [], geigerScore: '0.0').obs;

  //**** end of observable object***

  //****** start of public method *****
  void onScanButtonPressed() async {
    //begin scanning
    isScanning.value = true;
    //send a broadcast to external tool
    _requestScan();
    //set observable aggregate threatScore
    aggThreatsScore.value = await _getAggThreatScore();
    //cached data when the user press the scan button
    _cachedAggregateData(aggThreatsScore.value);
    //scanning is done
    //a delay
    await Future.delayed(Duration(seconds: 2));
    //set scanRequired to false if true
    isScanRequired.value = false;
    log("Dump => after onPressed Button *****************");
    log("${await _storageController.dump(":")}");

    isScanning.value = false;
  }

  //*** end public method *****

  //************* start of private methods ***********************

  void _requestScan() async {
    log("ScanButtonPressed called");
    await geigerApiInstance.getLocalMaster.scanButtonPressed();
    //await geigerApiInstance.getEvents();
  }

  //returns aggregate of GeigerScoreThreats
  Future<GeigerScoreThreats> _getAggThreatScore() async {
    String currentUserId = await _userService.getUserId;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String path =
        ":Users:$currentUserId:$indicatorId:data:GeigerScoreAggregate";
    GeigerScoreThreats geigerScoreThreats =
        await _geigerIndicatorHelper.getGeigerScoreThreats(path: path);

    return geigerScoreThreats;
  }

  //check if termsAndConditions were accepted
  // redirect to termAndCondition if false
  Future<bool> _redirect() async {
    bool checkTerms = await _termsAndConditionsController.isTermsAccepted();
    if (checkTerms == false) {
      await getX.Get.offNamed(Routes.TERMS_AND_CONDITIONS_VIEW);
      return false;
    }
    return true;
  }

  //********* start initial resources ***********

  //load utility data
  Future<void> _loadUtilityData() async {
    await _geigerUtilityData.storeCountry();
    await _geigerUtilityData.storeProfAss();
    await _geigerUtilityData.storeCerts();
    await _geigerUtilityData.setPublicKey();
  }

  Future<void> _initReplication() async {
    log("replication called");
    message.value = "Update....";

    //initialReplication
    message.value = "Preparing geigerToolbox...";

    // only initialize replication only when terms and conditions are accepted
    await _cloudReplicationInstance.initialReplication();
    await Future.delayed(Duration(seconds: 2));
    log("isLoading is : $isLoadingServices");
    message.value = "Almost done!";
  }

  Future<void> _initStorageResources() async {
    //get StorageController from localStorageController instance
    _storageController = await _localStorageInstance.getStorageController;
    _userService = GeigerUserService(_storageController);
    _geigerUtilityData = GeigerUtilityService(_storageController);
    _geigerIndicatorHelper = GeigerIndicatorService(_storageController);
  }

  void _runInitStorageRegister() async {
    // String currentDeviceId = await _userService.getDeviceId;
    // const String montimagePluginId = 'geiger-api-test-external-plugin-id';
    // const String sensorId = 'mi-ksp-scanner-is-rooted-device';
    //
    // String currentUserId = await _userService.getUserId;
    // String indicatorId = _indicatorControllerInstance.indicatorId;
    // String nodePath =
    //     ':Device:$currentDeviceId:$montimagePluginId:data:metrics:$sensorId';
    // String path =
    //     ":Users:$currentUserId:$indicatorId:data:GeigerScoreAggregate";

    await _localStorageInstance.initRegisterStorageListener((EventType event) {
      log("StorageListener got this event ==> $event");
      //Todo: implement a notification for Storage Event
      isStorageUpdated.value = event.toValueString();
      isScanRequired.value = true;
    }, ":Local", "currentUser");

    // // show snack bar if storageChanges
    // Get.snackbar("StorageEvent Message",
    //     "StorageListener got this event ==> $isStorageUpdated")
  }

  Future<void> _loadHelperData() async {
    isLoadingServices.value = true;
    message.value = "Loading Toolbox..";

    await Future.delayed(Duration(seconds: 1));

    //load utilityData
    await _loadUtilityData();

    message.value = "Updating Toolbox..";

    // await _initReplication();
    isLoadingServices.value = false;
  }

  Future<void> _triggerAggCachedData() async {
    //check if user has previously pressed the scanButton
    bool isButtonPressed = await _userService.isButtonPressed();
    //always true because it is set to true when the user accept termsAndConditions
    // for the first time
    if (isButtonPressed) {
      //update newUserStatus to false onScanButtonPressed
      getX.once(aggThreatsScore,
          (_) async => await _userService.updateButtonPressed());
      //log("${await _userService.checkNewUserStatus()}");
    } else {
      //populate data from cached
      await _showAggCachedData();
    }
  }

  //************* end of private methods ***********************

  @override
  void onInit() async {
    //init resources
    await _initStorageResources();
    bool isRedirect = await _redirect();
    if (isRedirect) {
      //load local Plugin
      await _loadHelperData();
    }

    await _triggerAggCachedData();

    super.onInit();
  }

  @override
  void onReady() async {
    if (grantPermission.isTrue) {
      await _initReplication();
    }
    //storageRegister
    _runInitStorageRegister();
    super.onReady();
  }

  Future<bool> updateDeviceInfo() async {
    try {
      NodeValue? nodeValue =
          await _storageController.getValue(":Local", "deviceInfo");
      var r = math.Random();
      nodeValue!.setValue("FHnwUserID${r.nextDouble()}");
      await _storageController.updateValue(":Local", nodeValue);

      return true;
    } catch (e) {
      log('Failed to get node :Local ');
      log(e.toString());
      return false;
    }
  }

  //**************cached data*******************
  final GetStorage cache = GetStorage();

  void _cachedAggregateData(GeigerScoreThreats value) {
    cache.write("aggThreat", jsonEncode(value));
  }

  GeigerScoreThreats _getAggCachedData() {
    var data = cache.read("aggThreat");
    var json = jsonDecode(data);
    GeigerScoreThreats result = GeigerScoreThreats.fromJson(json);
    return result;
  }

  // get data from cache if user has  press the scan button before
  Future<void> _showAggCachedData() async {
    //aggThreatsScore.value = await _getAggThreatScore();
    //update aggregate threatScore from cached data
    aggThreatsScore.value = _getAggCachedData();
  }
//********* end of initial resources ***********
}

// ****cached of recommendatin
// void _cachedUserData() async {
//   User? currentUser = await _userService.getUserInfo;
//   String indicatorId = _indicatorControllerInstance.indicatorId;
//   String path =
//       ":Users:${currentUser!.userId}:$indicatorId:data:GeigerScoreUser";
//   //get user geigerScoreThreats
//   GeigerScoreThreats geigerScoreThreats =
//   await _geigerIndicatorHelper.getGeigerScoreThreats(path: path);
//
//   cache.write("userThreat", jsonEncode(geigerScoreThreats));
// }
//
// void _cachedDeviceData() async {
//   User? currentUser = await _userService.getUserInfo;
//   String indicatorId = _indicatorControllerInstance.indicatorId;
//   String path =
//       ":Devices:${currentUser!.deviceOwner!.deviceId}:$indicatorId:data:GeigerScoreDevice";
//   //get device geigerScoreThreats
//   GeigerScoreThreats geigerScoreThreats =
//   await _geigerIndicatorHelper.getGeigerScoreThreats(path: path);
//
//   cache.write("deviceThreat", jsonEncode(geigerScoreThreats));
// }
//
// Future<void> cachedUserRecommendation(Threat threat) async {
//   User? currentUser = await _userService.getUserInfo;
//   String indicatorId = _indicatorControllerInstance.indicatorId;
//   String userRecommendationPath =
//       ":Users:${currentUser!.userId}:$indicatorId:data:recommendations";
//
//   String geigerScoreUserPath =
//       ":Users:${currentUser.userId}:$indicatorId:data:GeigerScoreUser";
//
//   List<Recommendation> geigerScoreThreats =
//   await _geigerIndicatorHelper.getGeigerRecommendations(
//       recommendationPath: userRecommendationPath,
//       threatId: threat.threatId,
//       geigerScorePath: geigerScoreUserPath);
//   cache.write("userRecommendations", jsonEncode(geigerScoreThreats));
// }
//
// Future<void> cachedDeviceRecommendation(Threat threat) async {
//   User? currentUser = await _userService.getUserInfo;
//   String indicatorId = _indicatorControllerInstance.indicatorId;
//   String deviceRecommendationpath =
//       ":Devices:${currentUser!.deviceOwner!.deviceId}:$indicatorId:data:recommendations";
//
//   String geigerScoreDevicePath =
//       ":Devices:${currentUser.deviceOwner!.deviceId}:$indicatorId:data:GeigerScoreDevice";
//
//   List<Recommendation> deviceRecommendation =
//   await _geigerIndicatorHelper.getGeigerRecommendations(
//       recommendationPath: deviceRecommendationpath,
//       threatId: threat.threatId,
//       geigerScorePath: geigerScoreDevicePath);
//
//   cache.write("deviceRecommendations", jsonEncode(deviceRecommendation));
// }
