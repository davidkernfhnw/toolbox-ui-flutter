import 'dart:convert';
import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/modules/termsAndConditions/controllers/terms_and_conditions_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/cloudReplication/cloud_replication_controller.dart';
import 'package:geiger_toolbox/app/services/dummyData/dummy_data_controller.dart';
import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
import 'package:geiger_toolbox/app/services/helpers/implementation/geiger_data.dart';
import 'package:geiger_toolbox/app/services/helpers/implementation/impl_user_service.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
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

  final CloudReplicationController _cloudReplicationInstance =
      CloudReplicationController.instance;
  final GeigerApiConnector geigerApiInstance = GeigerApiConnector.instance;

  // dummy instance
  final DummyStorageController _dummyStorageInstance =
      DummyStorageController.instance;

  late StorageController _storageController;
  late UserService _userService;
  late GeigerData _geigerUtilityData;

  var isScanning = false.obs;
  var isLoadingServices = false.obs;
  var message = "".obs;

  //Todo: do pass of data from the localstorage to ui

//initial aggregate threatScore
  getX.Rx<dummy.GeigerScoreThreats> aggThreatsScore =
      dummy.GeigerScoreThreats(threatScores: [], geigerScore: '').obs;

  //notify external tool that a scan is about to start
  void requestScan() async {
    await geigerApiInstance.getLocalMaster.scanButtonPressed();
  }

  void onScanButtonPressed() async {
    //begin scanning
    isScanning.value = true;

    requestScan();
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
  Future<dummy.GeigerScoreThreats> _getAggThreatScore() async {
    String currentUserId = await _userService.getUserId;
    NodeValue? nodeValueG = await _storageController.getValue(
        ":Users:${currentUserId}:gi:data:GeigerScoreAggregate", "GEIGER_score");
    NodeValue? nodeValueT = await _storageController.getValue(
        ":Users:${currentUserId}:gi:data:GeigerScoreAggregate",
        "threats_score");
    List<dummy.ThreatScore> t =
        dummy.ThreatScore.convertFromJson(nodeValueT!.value);

    return dummy.GeigerScoreThreats(
        threatScores: t, geigerScore: nodeValueG!.value);
  }

  // initialize storageController and userService before the ui loads
  Future<void> _initStorageController() async {
    //get StorageController from localStorageController instance
    _storageController = await _localStorageInstance.getStorageController;
    _userService = UserService(_storageController);
    _geigerUtilityData = GeigerData(_storageController);
  }

  Future<void> _initDummyStorageController() async {
    await _dummyStorageInstance.initLocalStorageDummy();
  }

  //**************cached data*******************
  final box = GetStorage();

  void _cachedData() {
    box.write("aggThreat", jsonEncode(aggThreatsScore.value));
  }

  dummy.GeigerScoreThreats _getCachedData() {
    var data = box.read("aggThreat");
    var json = jsonDecode(data);
    dummy.GeigerScoreThreats result = dummy.GeigerScoreThreats.fromJson(json);
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

  Future<void> _initReplication() async {
    isLoadingServices.value = true;
    message.value = "Update....";

    //initialReplication
    message.value = "Preparing geigerToolbox...";

    // only initialize replication only when terms and conditions are accepted
    await _cloudReplicationInstance.initialReplication();
    log("isLoading is : $isLoadingServices");
    message.value = "Almost done!";
    isLoadingServices.value = false;
    log("done Loading : $isLoadingServices");
  }

  // only set Dummy data and other utilityData if user is a new user
  Future<void> _initDummyData() async {
    await _dummyStorageInstance.setDummyData();
    return;
  }

  //check if termsAndConditions were accepted
  // redirect to termAndCondition if false
  Future<void> redirect() async {
    bool checkTerms = await _termsAndConditionsController.isTermsAccepted();
    if (checkTerms == false) {
      return getX.Get.offNamed(Routes.TERMS_AND_CONDITIONS_VIEW);
    } else {
      bool checkUser = await _userService.checkNewUserStatus();
      //Todo: fixed Bug
      // when hot reload is executed before the user pressed
      // the scan button after accepting terms and conditions
      // this check always be true
      if (checkUser == true) {
        isLoadingServices.value = true;
        message.value = "Loading..";
        //set dummyData
        await _initDummyData();
        await _geigerUtilityData.storeCountry();
        await _geigerUtilityData.storeProfAss();
        await _geigerUtilityData.storeCerts();
        await _geigerUtilityData.setPublicKey();
        await _initReplication();
        isLoadingServices.value = false;

        return;
      }
      //replication will not run again when a user press the scan button
      //await _initReplication();

      return;
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

  //Todo : add StorageListener
  //*********cloud replication

  // // testing purpose for data stored by replication
  // _getThreatWeight() async {
  //   Node node = await _storageController.get(":Global:ThreatWeight");
  //   List<String> threatsId =
  //       await node.getChildNodesCsv().then((value) => value.split(','));
  //   for (String id in threatsId) {
  //     Node threat = await _storageController.get(":Global:ThreatWeight:$id");
  //
  //     String? result = await threat
  //         .getValue("threatJson")
  //         .then((value) => value!.getValue("en"));
  //     log(result!);
  //   }
  // }
}
