import 'dart:convert';
import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_aggregate_score.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/services/cloudReplication/cloud_replication_controller.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:get/get.dart' as getX;

class HomeController extends getX.GetxController {
  //an instance of HomeController
  static HomeController get to => getX.Get.find();
  LocalStorageController _localStorage = LocalStorageController.instance;
  StorageController? _storageController;
  // dummy.GeigerDummy _geigerDummy = dummy.GeigerDummy();
  // dummy.UserNode? _userNode;
  // dummy.DeviceNode? _deviceNode;

  //storageController
  _init() async {
    //_storageController = await LocalStorage.initLocalStorage();
    _storageController = await _localStorage.getStorageController;
  }

  var isLoading = false.obs;

  //initial as an obs
  getX.Rx<GeigerAggregateScore> geigerAggregateScore =
      GeigerAggregateScore([], null, null).obs;

  //initial as a private list obs
  List<Threat> threatsScore = <Threat>[].obs;

  // populate static json data
  Future<List<Threat>> _fetchGeigerAggregateScore() async {
    const scoreAggJsonData = '''{
        "threatScores": [ {"threatId":"1234ph", "name":"Phishing", "score":{"score":"40.20"}}, {"threatId":"1234ml", "name":"Malware", "score" :{"score":"80.23"}}],
        "numberMetrics": "2",
        "geigerScore" : "62.0"
    }''';

    //delay by 1sec
    await Future.delayed(1000.milliseconds);
    GeigerAggregateScore aggScore =
        GeigerAggregateScore.fromJson(json.decode(scoreAggJsonData));
    //assign decode GeigerAggregateScore json
    geigerAggregateScore.value = aggScore;
    return geigerAggregateScore.value.threatScores;
  }

  setGeigerAggregateThreatScore() async {
    await _init();
    // _userNode = await dummy.UserNode(_storageController!);
    // _deviceNode = await dummy.DeviceNode(_storageController!);
    isLoading.value = true;
    threatsScore = await _fetchGeigerAggregateScore();
    getThreatWeight();
    // log(await _geigerDummy.onBtnPressed(_storageController!));
    // log(await _userNode!.getUserInfo
    //     .then((value) async => value.deviceOwner.deviceId!));
    // log(await _deviceNode!.getDeviceInfo
    //     .then((value) async => value.deviceId!));
    isLoading.value = false;
  }

  emptyThreatScores() {
    threatsScore = [];
  }

  @override
  void onInit() async {
    super.onInit();
    await _init();
  }

  //*********cloud replication

  getThreatWeight() async {
    Node node = await _storageController!.get(":Global:ThreatWeight");
    List<String> threatsId =
        await node.getChildNodesCsv().then((value) => value.split(','));
    for (String id in threatsId) {
      Node threat = await _storageController!.get(":Global:ThreatWeight:$id");

      String? result = await threat
          .getValue("threatJson")
          .then((value) => value!.getValue("en"));
      log(result!);
    }
  }
}
