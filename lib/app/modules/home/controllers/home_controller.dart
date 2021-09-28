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
  List<Threat> _threatsScore = <Threat>[].obs;

  // populate static json data
  fetchGeigerAggregateScore() {
    isLoading.value = true;
    const scoreAggJsonData = '''{
        "threatScores": [ {"threatId":"1234ph", "name":"Phishing", "score":{"score":"40.20"}}, {"threatId":"1234ml", "name":"Malware", "score" :{"score":"80.23"}}],
        "numberMetrics": "2",
        "geigerScore" : "62.0"
    }''';
    GeigerAggregateScore aggScore =
        GeigerAggregateScore.fromJson(json.decode(scoreAggJsonData));
    //assign decode GeigerAggregateScore json
    geigerAggregateScore.value = aggScore;

    _setGeigerAggregateThreatScore();

    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
  }

  _setGeigerAggregateThreatScore() {
    //pass List<Threat> threats and score
    _threatsScore = geigerAggregateScore.value.threatScores;
  }

  //return a list of threats and scores
  List<Threat> getGeigerAggregateThreatScore() {
    return _threatsScore;
  }
}
