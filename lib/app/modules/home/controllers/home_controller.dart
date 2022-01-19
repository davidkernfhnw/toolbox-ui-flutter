import 'dart:convert';
import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/modules/termsAndConditions/controllers/terms_and_conditions_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
import 'package:geiger_toolbox/app/services/indicator/geiger_indicator_controller.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_data.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_indicator_data.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/impl_user_service.dart';
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

  // final CloudReplicationController _cloudReplicationInstance =
  //     CloudReplicationController.instance;

  final GeigerIndicatorController _indicatorControllerInstance =
      GeigerIndicatorController.instance;
  final GeigerApiConnector geigerApiInstance = GeigerApiConnector.instance;

  //**** end of instance

  //**** late variables ******
  late final StorageController _storageController;
  late final UserService _userService;
  late final GeigerUtilityData _geigerUtilityData;
  late final GeigerIndicatorHelper _geigerIndicatorHelper;
  // *** end of late variables ****

  //**** observable variable ****
  var isScanning = false.obs;
  var isLoadingServices = false.obs;
  var message = "".obs;
  var scanRequired = false.obs;
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
    _cachedData();
    //scanning is done
    //a delay
    await Future.delayed(Duration(seconds: 2));
    //set scanRequired to false if true
    scanRequired.value = false;
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

  // ******start  StorageListener method
  Future<void> _registerLocalStorageUserListener() async {
    log("registeredLocalStorageListener called");
    String currentUserId = await _userService.getUserId;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String path = ":Users";
    String searchKey = "currentUser";
    Node _node = await _storageController.get(path);
    await _localStorageInstance.registerListener(_node, path, searchKey);
  }

  //trigger
  Future<bool> _triggerLocalStorageUserListener() async {
    log("triggerLocalStorageUserListener called");
    String currentUserId = await _userService.getUserId;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String path = ":Users";
    String searchKey = "currentUser";
    Node _node = await _storageController.get(path);
    return await _localStorageInstance.triggerListener(_node, path, searchKey);
  }

  //called this when ui is ready
  Future<void> _listenToLocalStorageUser() async {
    log("listToLocalStorage called");
    bool t = await _triggerLocalStorageUserListener();

    if (t == false) {
      List<Event> event =
          await _localStorageInstance.getLocalStorageListener.events;
      log("Events => $event");
      try {
        EventType update = event
            .firstWhere((Event element) => element.type == EventType.update)
            .type;
        log("Event Listener Type => $update");
        scanRequired.value = true;
      } catch (e) {
        scanRequired.value = false;
        log("Opp Something went wrong ==> $e");
      }
    } else {
      log("No changes is localStorage");
      scanRequired.value = false;
    }
  }

  //**********end of storageListener method

  //check if termsAndConditions were accepted
  // redirect to termAndCondition if false
  Future<void> _redirect() async {
    bool checkTerms = await _termsAndConditionsController.isTermsAccepted();
    if (checkTerms == false) {
      return getX.Get.offNamed(Routes.TERMS_AND_CONDITIONS_VIEW);
    }
  }

  Future<void> _initGeigerIndicator() async {
    log("initGeigerIndicator called");
    //start indicator
    await _indicatorControllerInstance.initGeigerIndicator();
  }

  //********* start initial resources ***********

  //load utility data
  Future<void> _loadUtilityData() async {
    await _geigerUtilityData.storeCountry();
    await _geigerUtilityData.storeProfAss();
    await _geigerUtilityData.storeCerts();
    await _geigerUtilityData.setPublicKey();
  }

  Future<void> _initStorageResources() async {
    //get StorageController from localStorageController instance
    _storageController = await _localStorageInstance.getStorageController;
    _userService = UserService(_storageController);
    _geigerUtilityData = GeigerUtilityData(_storageController);
    _geigerIndicatorHelper = GeigerIndicatorHelper(_storageController);
  }
  //********* end of initial resources ***********

  //**************cached data*******************
  final box = GetStorage();

  void _cachedData() {
    box.write("aggThreat", jsonEncode(aggThreatsScore.value));
  }

  GeigerScoreThreats _getCachedData() {
    var data = box.read("aggThreat");
    var json = jsonDecode(data);
    GeigerScoreThreats result = GeigerScoreThreats.fromJson(json);
    return result;
  }

  // get data from cache if user has  press the scan button before
  Future<void> _getCacheData() async {
    bool isNewUser = await _userService.checkNewUserStatus();
    log("new user : $isNewUser");
    if (isNewUser == false) {
      //aggThreatsScore.value = await _getAggThreatScore();
      //update aggregate threatScore from cached data
      aggThreatsScore.value = _getCachedData();
      return;
    }
  }

  Future<void> _loadPlugin() async {
    isLoadingServices.value = true;
    message.value = "Loading Toolbox..";

    await Future.delayed(Duration(seconds: 1));
    // bool checkUser = await _userService.checkNewUserStatus();
    // when hot reload is executed before the user pressed
    // the scan button after accepting terms and conditions
    // this check always be true
    //if (checkUser) {
    // isLoadingServices.value = true;
    // message.value = "Update..";
    //init indicator

    //register listener
    await _registerLocalStorageUserListener();
    await _initGeigerIndicator();

    await _triggerLocalStorageUserListener();
    //register listener

    //load utilityData
    await _loadUtilityData();
    //await Future.delayed(Duration(seconds: 1));

    message.value = "Updating Toolbox..";

    //await _initReplication();
    isLoadingServices.value = false;
  }

  //******************end cached data***********************

  //************* end of private methods ***********************

  @override
  void onInit() async {
    await _redirect();
    //load resources
    await _initStorageResources();

    //load local Plugin
    await _loadPlugin();

    //update newUserStatus to false onScanButtonPressed
    getX.once(
        aggThreatsScore, (_) async => await _userService.updateNewUserStatus());
    log("${await _userService.checkNewUserStatus()}");

    //populate data from cached
    await _getCacheData();
    log("${await _userService.getUserId}");
    log("Dump after loading*****************");
    log("${await _storageController.dump(":")}");

    super.onInit();
  }

  @override
  void onReady() async {
    //await _triggerLocalStorageUserListener();
    //await _listenToLocalStorageUser();
    super.onReady();
  }

  //*********cloud replication

  // // testing purpose for data stored by replication
  // _getThreatWeight() async {
  //   Node node = await _storageController.get(":Global:threats");
  //   List<String> threatsId =
  //       await node.getChildNodesCsv().then((value) => value.split(','));
  //   for (String id in threatsId) {
  //     Node threat = await _storageController.get(":Global:threats:$id");
  //
  //     String? result = await threat
  //         .getValue("threatJson")
  //         .then((value) => value!.getValue("en"));
  //     log(result!);
  //   }
  // }

// Future<void> _initReplication() async {
//   isLoadingServices.value = true;
//   message.value = "Update....";
//
//   //initialReplication
//   message.value = "Preparing geigerToolbox...";
//
//   // only initialize replication only when terms and conditions are accepted
//   await _cloudReplicationInstance.initialReplication();
//   log("isLoading is : $isLoadingServices");
//   message.value = "Almost done!";
//   isLoadingServices.value = false;
//   log("done Loading : $isLoadingServices");
// }

}
