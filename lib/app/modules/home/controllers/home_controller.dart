import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geiger_api/geiger_api.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/cloudReplication/cloud_replication_controller.dart';
import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
import 'package:geiger_toolbox/app/services/indicator/geiger_indicator_controller.dart';
import 'package:geiger_toolbox/app/services/localNotification/local_notification.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_indicator_service.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:get/get.dart' as getX;
import 'package:get_storage/get_storage.dart';

class HomeController extends getX.GetxController {
  //an instance of HomeController
  static HomeController get instance => getX.Get.find();

  //******* start of instance **********

  final LocalStorageController _localStorageInstance =
      getX.Get.find<LocalStorageController>();

  //get instance of GeigerApiConnector
  GeigerApiConnector _geigerApiConnectorInstance = GeigerApiConnector.instance;

  final CloudReplicationController _cloudReplicationInstance =
      CloudReplicationController.instance;

  final GeigerIndicatorController _indicatorControllerInstance =
      GeigerIndicatorController.instance;
  final GeigerApiConnector geigerApiInstance = GeigerApiConnector.instance;

  final LocalNotificationController _localNotificationControllerInstance =
      LocalNotificationController.instance;

  //**** end of instance

  //**** late variables ******
  late final StorageController _storageController;
  late final GeigerUserService _userService;
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

    log("Dump after scanning ==> ${await _storageController.dump(":")}");
    //set scanRequired to false if true
    isScanRequired.value = false;

    isScanning.value = false;
  }

  Color changeScanBtnColor(String score) {
    String weight = checkAggScoreLevel(score);
    if (weight == "Low") {
      return Colors.green;
    } else if (weight == "Medium") {
      return Colors.orangeAccent;
    } else if (weight == "High") {
      return Colors.red;
    } else {
      return Colors.red;
    }
  }

  String checkAggScoreLevel(String score) {
    double parse = double.parse(score);
    double result = parse.toPrecision(2);
    if (result >= 0.10 && result <= 100) {
      if (result <= 0.39) {
        return "Low";
      } else if (result >= 0.40 || result <= 0.70) {
        return "Medium";
      } else {
        return "High";
      }
    } else {
      return "invalid";
    }
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

  //check if terms and condition values is true in the localstorage
  // and navigate to home view (screen)
  //if false navigate to TermAndCondition view(screen).
  Future<bool> _isTermsAccepted() async {
    try {
      //get user Info
      User? userInfo = await _userService.getUserInfo;

      // assign user term and condition
      TermsAndConditions userTermsAndConditions = userInfo!.termsAndConditions;
      //check if true and return home view (screen)
      if (await userTermsAndConditions.ageCompliant == true &&
          await userTermsAndConditions.signedConsent == true &&
          await userTermsAndConditions.agreedPrivacy == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("UserInfo not found");
      return false;
    }
  }

  //check if termsAndConditions were accepted
  // redirect to termAndCondition if false
  Future<bool> _redirect() async {
    bool checkTerms = await _isTermsAccepted();

    if (checkTerms == false) {
      await getX.Get.offNamed(Routes.TERMS_AND_CONDITIONS_VIEW);
      return false;
    }
    return true;
  }

  //********* start initial resources ***********

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

    _geigerIndicatorHelper = GeigerIndicatorService(_storageController);
  }

  void _showNotification(String event) async {
    _localNotificationControllerInstance.notification(
        "Geiger ToolBox Notification", event);
  }

  void _runInitStorageRegister() async {
    // String currentDeviceId = await _userService.getDeviceId;
    // const String montimagePluginId = 'geiger-api-test-external-plugin-id';
    // const String sensorId = 'mi-ksp-scanner-is-rooted-device';
    //
    //String currentUserId = await _userService.getUserId;
    //String currentDeviceId = await _userService.getDeviceId;
    // String indicatorId = _indicatorControllerInstance.indicatorId;
    // String path =
    //     ":Users:$currentUserId:$indicatorId:data:GeigerScoreAggregate";

    await _localStorageInstance.initRegisterStorageListener(
        eventType: EventType.update,
        eventHandler: (EventType event) {
          isStorageUpdated.value = event.toValueString();
          isScanRequired.value = true;
          _showNotification(event.toValueString());
        },
        path: ":Local:ui",
        searchKey: "deviceInfo");
  }

  void _runInitRegisterExternalPluginListener() async {
    //get instance of GeigerApiConnector
    _geigerApiConnectorInstance.initRegisterExternalPluginListener(
        scanCompletedEventHandler: (Message msg) {
      _showNotification(
          'We have received the SCAN_COMPLETED event from ${msg.sourceId}');
      log('We have received the SCAN_COMPLETED event from ${msg.sourceId}');
      getX.Get.snackbar(
          '', 'The external plugin ${msg.sourceId} has finished the scanning');
    });
  }

  //Todo : Listen for a change in userConsent before calling indicator
  //Todo :if a user has not click the scan button show a loading screen
  Future<void> _loadIndicator() async {
    isLoadingServices.value = true;
    message.value = "Loading Toolbox..";

    _indicatorControllerInstance.initGeigerIndicator();

    message.value = "Updating Toolbox..";
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
      // is only called
      //if user as already accepted terms and condition
      await _loadIndicator();
    }

    await _triggerAggCachedData();

    super.onInit();
  }

  @override
  void onReady() async {
    //await _initReplication();

    //storageRegister
    _runInitStorageRegister();
    //ExternalPluginListener
    _runInitRegisterExternalPluginListener();

    super.onReady();
  }

//test method
  Future<bool> changeDeviceInfo() async {
    try {
      NodeValue? nodeValue =
          await _storageController.getValue(":Local:ui", "deviceInfo");
      var r = math.Random();
      nodeValue!.setValue("FHnwUserID${r.nextDouble()}");
      await _storageController.updateValue(":Local:ui", nodeValue);

      return true;
    } catch (e) {
      log('Failed to get node :Local:ui ');
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
//********* end of resources ***********
}
