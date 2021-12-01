import 'dart:convert';
//import 'dart:developer';

//import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;
//import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_aggregate_score.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
//import 'package:geiger_toolbox/app/services/local_storage.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //an instance of HomeController
  static HomeController get to => Get.find();

  //StorageController? _storageController;

  //dummy.UserNode? _userNode;
  //dummy.DeviceNode? _deviceNode;

  //storageController
  // _init() async {
  //   // _storageController = await LocalStorage.initLocalStorage();
  //
  //   //_userNode = await dummy.UserNode(_storageController!);
  //   //_deviceNode = await dummy.DeviceNode(_storageController!);
  // }

  var isLoading = false.obs;

  //initial as an obs
  Rx<GeigerAggregateScore> geigerAggregateScore =
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
    isLoading.value = true;
    threatsScore = await _fetchGeigerAggregateScore();
    //log(await _geigerApi!.onBtnPressed());
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
    //await _init();
  }
}
