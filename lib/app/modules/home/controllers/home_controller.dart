import 'dart:convert';
import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_aggregate_score.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/modules/termsAndConditions/controllers/terms_and_conditions_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/cloudReplication/cloud_replication_controller.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:get/get.dart' as getX;

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

  StorageController? _storageController;

  var isScanning = false.obs;
  var isLoading = false.obs;
  var message = "".obs;

  //Todo: do pass of data from the localstorage to ui
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

  onScan() async {
    await _init();
    // _userNode = await dummy.UserNode(_storageController!);
    // _deviceNode = await dummy.DeviceNode(_storageController!);
    isScanning.value = true;
    threatsScore = await _fetchGeigerAggregateScore();
    _getThreatWeight();
    // log(await _geigerDummy.onBtnPressed(_storageController!));
    // log(await _userNode!.getUserInfo
    //     .then((value) async => value.deviceOwner.deviceId!));
    // log(await _deviceNode!.getDeviceInfo
    //     .then((value) async => value.deviceId!));
    isScanning.value = false;
  }

  emptyThreatScores() {
    threatsScore = [];
  }

  // initialize storageController before the ui loads
  _init() async {
    //get StorageController from localStorageController instance
    _storageController = await _localStorageInstance.getStorageController;
  }

  @override
  void onInit() async {
    bool check = await _termsAndConditionsController.isTermsAccepted();
    if (check == false) {
      return getX.Get.offNamed(Routes.TERMS_AND_CONDITIONS_VIEW);
    }

    isLoading.value = true;
    await _init();
    message.value = "Loading....";

    //initialReplication
    message.value = "Preparing geigerToolbox...";

    // only initialize replication only when terms and conditions are accepted
    await _cloudReplicationInstance.initialReplication();
    log("isLoading is : $isLoading");
    message.value = "Almost done!";
    isLoading.value = false;
    log("done Loading : $isLoading");

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //*********cloud replication

  // testing purpose
  _getThreatWeight() async {
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
