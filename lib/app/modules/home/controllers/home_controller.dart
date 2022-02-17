import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geiger_api/geiger_api.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/model/user.dart';
import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
import 'package:geiger_toolbox/app/services/indicator/geiger_indicator_controller.dart';
import 'package:geiger_toolbox/app/services/listeners/storage_event.dart';
import 'package:geiger_toolbox/app/services/localNotification/local_notification.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_data_service.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:get/get.dart' as getX;
import 'package:get_storage/get_storage.dart';

import '../../../model/recommendation.dart';
import '../../../model/terms_and_conditions.dart';
import '../../../routes/app_routes.dart';
import '../../settings/controllers/data_protection_controller.dart';

class HomeController extends getX.GetxController {
  //an instance of HomeController
  static HomeController get instance => getX.Get.find();

  //******* start of instance **********

  final LocalStorageController _localStorageInstance =
      LocalStorageController.instance;

  //get instance of GeigerApiConnector
  GeigerApiConnector _geigerApiConnectorInstance = GeigerApiConnector.instance;

  final GeigerIndicatorController _indicatorControllerInstance =
      GeigerIndicatorController.instance;
  final GeigerApiConnector geigerApiInstance = GeigerApiConnector.instance;

  final DataProtectionController _dataProtectionController =
      DataProtectionController.instance;

  final LocalNotificationController _localNotificationControllerInstance =
      LocalNotificationController.instance;

  final Event event = Event(EventType.update, null, null);
  //**** end of instance

  //**** late variables ******
  late final StorageController _storageController;
  late final GeigerUserService _userService;
  late final GeigerDataService _geigerDataService;

  // *** end of late variables ****

  //**** observable variable ****
  var isScanning = false.obs;
  var isLoadingServices = false.obs;
  var message = "".obs;
  var isScanRequired = false.obs;
  var isScanCompleted = "".obs;
  var isStorageUpdated = "".obs;
  //Todo: take this variable to data_protection_controller

  //**** end of observable variable ***

  //*** observable object *****
  // aggregate threatScore
  getX.Rx<GeigerScoreThreats> aggThreatsScore =
      GeigerScoreThreats(threatScores: [], geigerScore: '0.0').obs;

  //user recommendation
  getX.RxList<Recommendation> userGlobalRecommendations =
      <Recommendation>[].obs;
  //device recommendation
  getX.RxList<Recommendation> deviceGlobalRecommendations =
      <Recommendation>[].obs;

  //**** end of observable object***

  //****** start of public method *****
  void onScanButtonPressed() async {
    //begin scanning
    isScanning.value = true;
    await Future.delayed(Duration(milliseconds: 50));
    //send a broadcast to external tool
    _requestScan();

    //set observable aggregate threatScore
    aggThreatsScore.value = await _getAggThreatScore();
    //cached data when the user press the scan button
    _cachedAggregateData(aggThreatsScore.value);

    //get recommendations
    userGlobalRecommendations.value = await _getUserRecommendation();
    await Future.delayed(Duration(milliseconds: 200));
    deviceGlobalRecommendations.value = await _getDeviceRecommendation();
    _cachedUserAndDeviceRecommendation(
        user: userGlobalRecommendations, device: deviceGlobalRecommendations);
    //scanning is done

    // log("Dump after scanning ==> ${await _storageController.dump(":")}");
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
        await _geigerDataService.getGeigerScoreThreats(path: path);

    return geigerScoreThreats;
  }

  //Todo: take this method to data_protection_controller
  //check if termsAndConditions were accepted
  // redirect to termAndCondition if false

  //********* start initial resources ***********

  void _showNotification(String event) async {
    _localNotificationControllerInstance.notification(
        "Geiger ToolBox Notification", event);
  }

  void _aggDataUpdateListener() async {
    String currentUserId = await _userService.getUserId;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String path =
        ":Users:$currentUserId:$indicatorId:data:GeigerScoreAggregate";

    await _localStorageInstance.initRegisterStorageListener(
        event: EventType.update,
        eventHandlerCallback: (Event event) async {
          isStorageUpdated.value = event.type.toValueString();
          isScanRequired.value = true;
          log(":Local:ui event ${event.type} received");
          log("New Node => ${event.newNode}");
          log(":Local:ui listener id => ${await _localStorageInstance.getLocalStorageListener.hashCode}");
          _showNotification(
              "LocalStorage ${event.type.toValueString()} new scan required.");
        },
        path: path,
        searchKey: "GEIGER_score");
  }

  void _scanCompleteListener() async {
    //get instance of GeigerApiConnector
    _geigerApiConnectorInstance.initRegisterExternalPluginListener(
        scanCompletedEventHandler: (Message msg) {
      _showNotification('An external plugin  ${msg.type}.');
      log('We have received the SCAN_COMPLETED event from ${msg.sourceId}');
      //   getX.Get.snackbar(
      //       '', 'The external plugin ${msg.sourceId} has finished the scanning');
    });
  }

  Future<void> _loadIndicatorWithUpdateDetails() async {
    isLoadingServices.value = true;
    message.value = "Updating Toolbox...";
    await Future.delayed(Duration(seconds: 1));
    _indicatorControllerInstance.initGeigerIndicator();
    isLoadingServices.value = false;
  }

  Future<void> _loadIndicator() async {
    isLoadingServices.value = true;
    message.value = "Updating Toolbox...";
    _indicatorControllerInstance.initGeigerIndicator();
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
      _showAggCachedData();
      _getRecommendationCachedData();
    }
  }

  Future<void> _checkConsent() async {
    bool? result = await _userService.checkUserConsent();
    if (result != null) {
      if (result) {
        _dataProtectionController.setDataAccess = true;
        bool isFirstPressed = await _userService.isButtonPressed();
        if (!isFirstPressed) {
          await _loadIndicator();
        } else {
          //load this when user as not pressed the scan Button ever
          await _loadIndicatorWithUpdateDetails();
        }
      } else {
        _dataProtectionController.setDataAccess = false;
      }
    }
  }

  //check if terms and condition values is true in the localstorage
  // and navigate to Setting(screen)
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

  //Todo: take this method to data_protection_controller
  //check if termsAndConditions were accepted
  // redirect to termAndCondition view if false else
  // then check for userConsent if true
  // redirect to Home view
  //else remain in setting screen

  Future<bool> _redirect() async {
    isLoadingServices.value = true;
    bool checkTerms = await _isTermsAccepted();

    if (checkTerms == false) {
      await getX.Get.offNamed(Routes.TERMS_AND_CONDITIONS_VIEW);
      isLoadingServices.value = false;
      return false;
    } else {
      bool? result = await _userService.checkUserConsent();

      if (result! == false) {
        await getX.Get.offNamed(Routes.SETTINGS_VIEW);
        isLoadingServices.value = false;
        return false;
      } else {
        isLoadingServices.value = false;
        return true;
      }
    }
  }

  //************* end of private methods ***********************

  //**************Recommendation ***************

  Future<List<Recommendation>> _getDeviceRecommendation() async {
    User? currentUser = await _userService.getUserInfo;
    String indicatorId = _indicatorControllerInstance.indicatorId;

    String geigerScoreDevicePath =
        ":Devices:${currentUser!.deviceOwner!.deviceId}:$indicatorId:data:GeigerScoreDevice";

    List<Recommendation> deviceRecommendation = await _geigerDataService
        .getGeigerRecommendations(geigerScorePath: geigerScoreDevicePath);

    log("Device Recommendation ==> $deviceGlobalRecommendations");
    return deviceRecommendation;
  }

  Future<List<Recommendation>> _getUserRecommendation() async {
    User? currentUser = await _userService.getUserInfo;
    String indicatorId = _indicatorControllerInstance.indicatorId;

    String geigerScoreUserPath =
        ":Users:${currentUser!.userId}:$indicatorId:data:GeigerScoreUser";

    List<Recommendation> userRecommendation = await _geigerDataService
        .getGeigerRecommendations(geigerScorePath: geigerScoreUserPath);

    //log("User Recommendation => $userGeigerRecommendations");
    log("User Recommendation dump==> $userGlobalRecommendations");
    return userRecommendation;
  }

  //************** end Recommendation ***************

  Future<void> _initStorageResources() async {
    //get StorageController from localStorageController instance
    _storageController = await _localStorageInstance.getStorageController;
    _userService = GeigerUserService(_storageController);
    _geigerDataService = GeigerDataService(_storageController);
  }

  @override
  void onInit() async {
    //init resources
    await _initStorageResources();
    bool redirect = await _redirect();
    if (redirect) {
      //check userConsent before load indication
      _checkConsent();

      //storageRegister
      _aggDataUpdateListener();
      //ExternalPluginListener
      _scanCompleteListener();

      await _triggerAggCachedData();
    }
    super.onInit();
  }

  @override
  void onReady() async {
    //await _initReplication();
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

  void _cachedUserAndDeviceRecommendation(
      {required List<Recommendation> user,
      required List<Recommendation> device}) {
    cache.write("userRecommendation", jsonEncode(user));
    cache.write("deviceRecommendation", jsonEncode(device));
  }

  GeigerScoreThreats _getAggCachedData() {
    var data = cache.read("aggThreat");
    var json = jsonDecode(data);
    GeigerScoreThreats result = GeigerScoreThreats.fromJson(json);
    return result;
  }

  List<Recommendation> _getUserRecommendationCachedData() {
    var userReco = cache.read("userRecommendation");
    List<Recommendation> result = Recommendation.recommendationList(userReco);
    log("User Recommendation json ==> $result");
    return result;
  }

  List<Recommendation> _getDeviceRecommendationCachedData() {
    var deviceReco = cache.read("deviceRecommendation");
    List<Recommendation> result = Recommendation.recommendationList(deviceReco);
    return result;
  }

  // get data from cache if user has  press the scan button before
  void _showAggCachedData() async {
    //update aggregate threatScore from cached data
    aggThreatsScore.value = _getAggCachedData();
  }

  void _getRecommendationCachedData() async {
    userGlobalRecommendations.value = _getUserRecommendationCachedData();
    deviceGlobalRecommendations.value = _getDeviceRecommendationCachedData();
    log("user recomm obs => $userGlobalRecommendations");
  }
//********* end cache ***********
}
