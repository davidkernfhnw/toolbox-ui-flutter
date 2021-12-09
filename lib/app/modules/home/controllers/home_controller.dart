import 'dart:convert';
import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/services/dummy_storage_controller.dart';

import 'package:geiger_toolbox/app/services/ui_storage_controller.dart';
import 'package:get/get.dart' as getx;

class HomeController extends getx.GetxController {
  //an instance of HomeController
  static HomeController get to => getx.Get.find();
  UiStorageController _uiStorageControllerInstance =
      UiStorageController.instance;
  DummyStorageController _dummyStorageInstance =
      DummyStorageController.instance;
  late final StorageController storageController;
  late final StorageController storageControllerUi;

  dummy.GeigerDummy _geigerDummy = dummy.GeigerDummy();
  dummy.UserNode? _userNode;
  dummy.DeviceNode? _deviceNode;

  //storageController
  Future<void> _init() async {
    storageController = _dummyStorageInstance.getDummyController;
    storageControllerUi = await _uiStorageControllerInstance.getUiController;
    //_storageController = await LocalStorage.initLocalStorage();
    // _storageControllerDummy = await _localStorage.storageControllerDummy;
    //_storageControllerUi = await _localStorage.storageControllerUi;
  }

  var isLoading = false.obs;

  //initial as an obs
  getx.Rx<GeigerScoreThreats> geigerAggregateScore =
      GeigerScoreThreats(threatScores: [], geigerScore: '').obs;

  //initial as a private list obs
  getx.Rx<dummy.GeigerScoreThreats> aggThreatsScore =
      dummy.GeigerScoreThreats(threatScores: [], geigerScore: '').obs;

  // populate static json data
  Future<GeigerScoreThreats> _fetchGeigerAggregateScore() async {
    const scoreAggJsonData = '''{
        "threatScores": [ {"threat":{"threatId":"1234ph", "name":"Phishing"}, "score":"40.20"}, {"threat":{"threatId":"1234ml", "name":"Malware"}, "score" :"80.23"}],
        "geigerScore" : "62.0"
    }''';

    //delay by 1sec
    await Future.delayed(1000.milliseconds);
    GeigerScoreThreats aggScore =
        GeigerScoreThreats.fromJson(json.decode(scoreAggJsonData));

    //assign decode GeigerAggregateScore json
    geigerAggregateScore.value = aggScore;
    return geigerAggregateScore.value;
  }

  getAggrFromDataBase() async {
    var result = await _geigerDummy.onBtnPressed(storageController);
    var json = jsonDecode(result);
    dummy.GeigerData g = dummy.GeigerData.fromJson(json);
    List<dummy.GeigerScoreThreats> gts = g.geigerScoreThreats;
    dummy.GeigerScoreThreats agg = gts.last;
    aggThreatsScore.value = agg;
    log("Geiger Data: $agg");
  }

  setGeigerAggregateThreatScore() async {
    _userNode = await dummy.UserNode(storageController);
    _deviceNode = await dummy.DeviceNode(storageController);
    isLoading.value = true;
    //test without DataBase data
    //threatsScore.value = await _fetchGeigerAggregateScore();
    getAggrFromDataBase();
    log("previous Agreed");
    //await _localStorage.upNewUser(false);

    //listen if node is created
    //await listen();
    //get node from dummy
    //await getNodeFromDummy();
    // log(await _userNode!.getUserInfo
    //     .then((value) async => value.deviceOwner.deviceId!));
    // log(await _deviceNode!.getDeviceInfo
    //     .then((value) async => value.deviceId!));

    isLoading.value = false;
  }
  //listen to change in aggThreatScore

  emptyThreatScores() {
    aggThreatsScore.value.threatScores.clear();
  }

  // Future<String> getUserIdUi() async {
  //   NodeValue? nodeValue =
  //       await _storageControllerUi.getValue(":Local", "currentUser");
  //   return nodeValue!.value;
  // }

  Future<String> getUserIdDummy() async {
    NodeValue? nodeValue =
        await storageController.getValue(":Local", "currentUser");
    return nodeValue!.value;
  }

  // Future<void> listen() async {
  //   String currentUserId = await getUserIdUi();
  //   Node node = await getNodeFromDummy();
  //   //   List<Event> e = await _localStorage.listenToStorage(node);
  //   //print("Update : $e");
  // }

  // Future<Node> getNodeFromDummy() async {
  //   String currentUserId = await getUserIdUi();
  //   Node node = await storageController
  //       .get(":Users:${currentUserId}:gi:data:GeigerScoreAggregate");
  //
  //   return node;
  // }

  @override
  void onInit() async {
    super.onInit();
    await _init();

    //update newUser
    getx.once(
        aggThreatsScore, (_) => _uiStorageControllerInstance.upNewUser(false));
    //getAggrFromDataBase();
    //update newUser

    //String currentUserId = await getUserIdUi();
    //log("Userid using storageControllerUi: ${currentUserId}");
    log("Userid using storageControllerDummy: ${await getUserIdDummy()}");
    //listen();
  }

  @override
  void onReady() async {
    super.onReady();
    bool isNewUser = await _uiStorageControllerInstance.isNewUser();
    log("new user homeController: $isNewUser");
    if (isNewUser == false) {
      getAggrFromDataBase();
    }
  }
}

//when listener event is 2 means
// there is an update
