import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/data/model/global_recommendation.dart';
import 'package:geiger_toolbox/app/data/model/indicator_recommendation.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/data/model/threat_score.dart';
import 'package:geiger_toolbox/app/data/parsing/global_node.dart';

class GeigerNode extends GlobalNode{
  GeigerNode(this.storageController) : super(storageController);

  final StorageController storageController;


  Future<GeigerScoreThreats> getGeigerScoreThreats({required String path}) async {
  List<ThreatScore> threatsScore = [];
  late String geigerScore;
    try {
      NodeValue? nodeValueG = await storageController.getValue(
          path,
          "GEIGER_score");

      geigerScore = nodeValueG!.value;

      NodeValue? nodeValueT = await storageController.getValue(
          path
          "threats_score");

      String threatScore = nodeValueT!.value;

      List<String> splitThreatScores =
      threatScore.split(";"); // split on semi-colon

      for (String splitThreatScore in splitThreatScores) {
        List<String> tS = splitThreatScore.split(",");
        String threatId = tS[0];
        String score = tS[1];
        //return only phishing and malware
        List<Threat> threats = await _getLimitedThreats();

        //filter
        Threat threat =
        threats.where((Threat element) => element.threatId == threatId).toList().first;
        ThreatScore t = ThreatScore(threat: threat, score: score);
        //add to threatsScore
        threatsScore.add(t);
      }
      return GeigerScoreThreats(
          threatScores: threatsScore, geigerScore: geigerScore);
    }
    on StorageException{
      rethrow;
    }
  }

  //return only phishing and malware
  Future<List<Threat>> _getLimitedThreats()async{
    List<Threat> threats = await getGlobalThreats();
    List<Threat> t = [];
    try{
      //search
      Threat phishing = threats.where((Threat value) => value.name.toLowerCase() == "phishing").toList().first;
      Threat malware = threats.where((Threat value) => value.name.toLowerCase() == "malware").toList().first;
      t.add(phishing);
      t.add(malware);
    }
    catch(e){
      log("Phishing and malware not found in the database");

    }

    return t;


  }


  Future<List<IndicatorRecommendation>> _getIndicatorRecommendation({required String path, required String threatId}) async{
    List<IndicatorRecommendation> indicatorRecommendation = [];
    try{
      NodeValue? nodeValueI = await storageController.getValue(
          path, threatId);
      

      String reco = nodeValueI!.value;

      //check if empty
      if(reco.isEmpty){
        // return empty indicatorRecommendation list
        return indicatorRecommendation;
      }
      else{
        List<String> recoSplit = reco.split(";");//split on semi-colon
        log("indicatorRecommendation: $recoSplit");

        for(String reco in recoSplit){
          List<String> rI = reco.split(",");
          String recomId = rI[0];//recomId
          String weight = rI[1];// weight Level
          indicatorRecommendation.add(IndicatorRecommendation(recommendationId: recomId, weight: weight));
        }

      }
      return indicatorRecommendation;
    }
    on StorageException{
      rethrow;
    }
  }
  
  
  Future<List<GlobalRecommendation>> getGeigerRecommendations({required String path, required String threatId})async{
    List<GlobalRecommendation> r = [];
    List<IndicatorRecommendation> indicatorRecommendations = await _getIndicatorRecommendation(path: path, threatId: threatId);
    List<GlobalRecommendation> globalRecommendation = await getGlobalRecommendations();

    //check if indicatorRecommendation is empty
    if(indicatorRecommendations.isNotEmpty){
      for(IndicatorRecommendation indicatorRecommendation in indicatorRecommendations){

        GlobalRecommendation recommendation = globalRecommendation.where((GlobalRecommendation value) => value.recommendationId == indicatorRecommendation.recommendationId).toList().first;
        r.add(recommendation);
      }
      return r;
    }
    else{
    //exit the loop
      //return empty list
    return r;
    }


  }
}
