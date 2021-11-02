import 'dart:convert';
import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '/app/data/model/geiger_aggregate_score.dart';
import '/app/data/model/threat.dart';
import '/app/repository/local_storage.dart';

class HomeController extends GetxController {
  StorageController? _storageController;

  //an instance of HomeController
  static HomeController get to => Get.find();
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

  emptyThreatScores() {
    threatsScore = [];
  }

  //testing with geiger_dummy_data

  setGeigerAggregateThreatScore() {
    //LocalStorage(storageController: _storageController).clearDatabase();
    log("currentUser: " + getUser.toString());
    log("currentDevice: " + getDevice.toString());
    log("aggThreatScore: " + getAggThreatScore.toString());

    log("user threatScore:" + getUserThreatScore.toString());
    log("device threatScore:" + getDeviceThreatScore.toString());
  }

  get getUser {
    try {
      return LocalStorage(storageController: _storageController!)
          .getCurrentUser;
    } catch (e) {
      log("CurrentUser does not exist");
    }
  }

  get getDevice {
    try {
      return LocalStorage(storageController: _storageController!)
          .getCurrentDevice;
    } catch (e) {
      log("CurrentDevice does not exist");
    }
  }

  get getAggThreatScore {
    return LocalStorage(storageController: _storageController)
        .getAggregateThreatScore();
  }

  get getUserThreatScore {
    return LocalStorage(storageController: _storageController!)
        .getGeigerScoreUserThreatScore();
  }

  get getDeviceThreatScore {
    return LocalStorage(storageController: _storageController!)
        .getGeigerScoreDeviceThreatScore();
  }

  //initialize this inside onInit() in your controller
  Future<void> _initLocalStorage() async {
    String dbPath = join(await getDatabasesPath(), 'database0.sqlite');
    try {
      _storageController = GenericController('test3', SqliteMapper(dbPath));
      //LocalStorage(storageController: _storageController).clearDatabase();
      LocalStorage(storageController: _storageController).setUserInfo();
      LocalStorage(storageController: _storageController).setDeviceInfo();
      LocalStorage(storageController: _storageController).setThreat();
      LocalStorage(storageController: _storageController).setGeigerUserScore();
      LocalStorage(storageController: _storageController)
          .setGeigerDeviceScoreThreatScore();
      LocalStorage(storageController: _storageController)
          .setAggregateThreatScore();
    } catch (e, stack) {
      //throw Exception("Database Connection: Failed");
      log("Database Connection: Failed \n $e \n $stack");
      log(dbPath);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    //connection to localStorage
    await _initLocalStorage();
    //store data in localstorage
  }

  @override
  void onClose() {
    super.onClose();
    _storageController!.close();
  }
}
