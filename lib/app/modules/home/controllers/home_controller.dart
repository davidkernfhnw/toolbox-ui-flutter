import 'dart:convert';
import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/data/model/recommendations_models.dart';
import 'package:geiger_toolbox/app/services/dummy_storage_controller.dart';

import 'package:geiger_toolbox/app/services/ui_storage_controller.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';

class HomeController extends getx.GetxController {
  //an instance of HomeController
  static HomeController get to => getx.Get.find();
  UiStorageController _uiStorageControllerInstance =
      UiStorageController.instance;
  DummyStorageController _dummyStorageInstance =
      DummyStorageController.instance;
  //late final StorageController storageControllerDummy;
  late final StorageController storageControllerUi;
  var isLoading = false.obs;

  //storageController
  Future<void> _init() async {
    //storageControllerDummy = _dummyStorageInstance.getDummyController;
    storageControllerUi = await _uiStorageControllerInstance.getUiController;
    //_storageController = await LocalStorage.initLocalStorage();
    // _storageControllerDummy = await _localStorage.storageControllerDummy;
    //_storageControllerUi = await _localStorage.storageControllerUi;
  }

  Future<String> _getUserId() async {
    NodeValue? nodeValue =
        await storageControllerUi.getValue(":Local", "currentUser");
    return nodeValue!.value;
  }

  //initial as a private list obs
  getx.Rx<dummy.GeigerScoreThreats> aggThreatsScore =
      dummy.GeigerScoreThreats(threatScores: [], geigerScore: '').obs;

  Future<dummy.GeigerScoreThreats> _getAggThreatScore() async {
    String currentUserId = await _getUserId();
    NodeValue? nodeValueG = await storageControllerUi.getValue(
        ":Users:${currentUserId}:gi:data:GeigerScoreAggregate", "GEIGER_score");
    NodeValue? nodeValueT = await storageControllerUi.getValue(
        ":Users:${currentUserId}:gi:data:GeigerScoreAggregate",
        "threats_score");
    List<dummy.ThreatScore> t =
        dummy.ThreatScore.convertFromJson(nodeValueT!.value);

    return dummy.GeigerScoreThreats(
        threatScores: t, geigerScore: nodeValueG!.value);
  }

  onScanSetGeigerAgg() async {
    isLoading.value = true;
    //delay by 3sec
    await Future.delayed(Duration(seconds: 2));
    aggThreatsScore.value = await _getAggThreatScore();
    _cachedData();
    isLoading.value = false;
  }

  emptyThreatScores() {
    aggThreatsScore.value.threatScores.clear();
  }

//listen to change in aggThreatScore
  Future<void> listenToStorage() async {
    Node node = await _getNodeFromDummy();
    List<Event> e = await _uiStorageControllerInstance.listenToStorage(node);
    print("Update : $e");
  }

  //
  Future<Node> _getNodeFromDummy() async {
    String currentUserId = await _getUserId();
    Node node = await storageControllerUi
        .get(":Users:${currentUserId}:gi:data:GeigerScoreAggregate");

    return node;
  }

  //cached data
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

  @override
  void onInit() async {
    super.onInit();
    await _init();

    //update newUser
    getx.once(
        aggThreatsScore, (_) => _uiStorageControllerInstance.upNewUser(false));
    //listen();
    //await listenToStorage();
  }

  @override
  void onReady() async {
    super.onReady();
    bool isNewUser = await _uiStorageControllerInstance.isNewUser();
    log("new user homeController: $isNewUser");
    if (isNewUser == false) {
      //aggThreatsScore.value = await _getAggThreatScore();
      aggThreatsScore.value = _getCachedData();
    }
  }
}

//when listener event is 2 means
// there is an update
