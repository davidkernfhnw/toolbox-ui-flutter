import 'package:geiger_toolbox/app/data/model/geiger_aggregate_score.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';

import 'dart:convert';
import 'package:get/get.dart';

class HomeController extends GetxController {
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

  setGeigerAggregateThreatScore() async {
    isLoading.value = true;
    threatsScore = await _fetchGeigerAggregateScore();
    isLoading.value = false;
  }

  emptyThreatScores() {
    threatsScore = [];
  }
}

//Todo
//refactor fetchGeigerAggregateScore() to return a Future
//so that you can delay the loading process
// in other to see the CircularProgressIndicator in homePage
