import 'dart:convert';
import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/data/model/global_recommendation.dart';
import 'package:geiger_toolbox/app/data/model/recommendation.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_toolbox/app/modules/termsAndConditions/controllers/terms_and_conditions_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/dummyData/dummy_data_controller.dart';
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

  //get instances
  final LocalStorageController _localStorageInstance =
      LocalStorageController.instance;

  final TermsAndConditionsController _termsAndConditionsController =
      TermsAndConditionsController.instance;

  // final CloudReplicationController _cloudReplicationInstance =
  //     CloudReplicationController.instance;
  final GeigerIndicatorController _indicatorControllerInstance =
      GeigerIndicatorController.instance;
  // dummy instance
  final DummyStorageController _dummyStorageInstance =
      DummyStorageController.instance;

  late StorageController _storageController;
  late UserService _userService;
  late GeigerData _geigerUtilityData;
  late GeigerIndicatorData _geigerIndicatorData;

  var isScanning = false.obs;
  var isLoadingServices = false.obs;
  var message = "".obs;

  //Todo: do pass of data from the localstorage to ui

//initial aggregate threatScore
  getX.Rx<GeigerScoreThreats> aggThreatsScore =
      GeigerScoreThreats(threatScores: [], geigerScore: '').obs;

  void onScanButtonPressed() async {
    //begin scanning
    isScanning.value = true;
    await Future.delayed(Duration(seconds: 2));

    aggThreatsScore.value = await _getAggThreatScore();

    //cached data when the user press the scan button
    _cachedData();
    //scanning is done
    isScanning.value = false;
  }

  //clear existing data before starting a new scan
  emptyThreatScores() {
    aggThreatsScore.value.threatScores.clear();
  }

  //returns aggregate of GeigerScoreThreats
  Future<GeigerScoreThreats> _getAggThreatScore() async {
    String currentUserId = await _userService.getUserId;
    String indicatorId = _indicatorControllerInstance.indicatorId;
    String path =
        ":Users:$currentUserId:$indicatorId:data:GeigerScoreAggregate";
    GeigerScoreThreats geigerScoreThreats =
        await _geigerIndicatorData.getGeigerScoreThreats(path: path);

    return geigerScoreThreats;
  }

  // initialize storageController and userService before the ui loads
  Future<void> _initStorageController() async {
    //get StorageController from localStorageController instance
    _storageController = await _localStorageInstance.getStorageController;
    _userService = UserService(_storageController);
    _geigerUtilityData = GeigerData(_storageController);
    _geigerIndicatorData = GeigerIndicatorData(_storageController);
  }

  Future<void> _initDummyStorageController() async {
    await _dummyStorageInstance.initLocalStorageDummy();
  }

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

  //******************end***********************

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

  // only set Dummy data and other utilityData if user is a new user
  // Future<void> _initDummyData() async {
  //   await _dummyStorageInstance.setDummyData();
  //   return;
  // }

  //load utility data
  void loadUtilityData() async {
    await _geigerUtilityData.storeCountry();
    await _geigerUtilityData.storeProfAss();
    await _geigerUtilityData.storeCerts();
    await _geigerUtilityData.setPublicKey();
  }

  //check if termsAndConditions were accepted
  // redirect to termAndCondition if false
  Future<void> redirect() async {
    bool checkTerms = await _termsAndConditionsController.isTermsAccepted();
    if (checkTerms) {
      bool checkUser = await _userService.checkNewUserStatus();
      // when hot reload is executed before the user pressed
      // the scan button after accepting terms and conditions
      // this check always be true
      if (checkUser) {
        isLoadingServices.value = true;
        message.value = "Loading..";
        //set dummyData
        //await _initDummyData();
        await Future.delayed(Duration(seconds: 1));
        //start indicator
        await _indicatorControllerInstance.initGeigerIndicator();
        loadUtilityData();

        //await _initReplication();
        isLoadingServices.value = false;

        return;
      } else {
        //replication will not run again when a user press the scan button
        //await _initReplication();
        return;
      }
    } else {
      return getX.Get.offNamed(Routes.TERMS_AND_CONDITIONS_VIEW);
    }
  }

  @override
  void onInit() async {
    await _initStorageController();
    await _initDummyStorageController();
    //update newUserStatus to false onScanButtonPressed
    getX.once(
        aggThreatsScore, (_) async => await _userService.updateNewUserStatus());
    log("${await _userService.checkNewUserStatus()}");
    await redirect();
    //populate data from cached
    await _getCacheData();

    super.onInit();
  }

  @override
  void onReady() {
    _getThreat();
  }
  //Todo : add StorageListener
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

  //for testing Indicator data
  _getThreat() async {
    List<Threat> r = await _geigerIndicatorData.getGlobalThreats();
    List<Threat> l = await _geigerIndicatorData.getLimitedThreats();
    List<GlobalRecommendation> g =
        await _geigerIndicatorData.getGlobalRecommendations();
    log("******Global********");
    log("Global Threats ==> $r");
    log("Limited Global Threats ==> $l");
    log("Global Recommendations ==> $g");
    GeigerScoreThreats u = await _getUserThreatScore();
    log("user threats ==> $u");
    // GeigerScoreThreats d = await _getDeviceThreatScore();
    // log("device threats ==> $d");
    List<Recommendation> uR = await _getUserRecommendation();
    log("User recommendation ==> $uR");
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
    List<Recommendation> geigerScoreThreats =
        await _geigerIndicatorData.getGeigerRecommendations(
            path: path, threatId: '80efffaf-98a1-4e0a-8f5e-gr89388350ma');

    return geigerScoreThreats;
  }
}
