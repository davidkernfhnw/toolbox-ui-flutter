import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/data/model/global_recommendation.dart';
import 'package:geiger_toolbox/app/data/model/indicator_recommendation.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/data/model/threat_score.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/abstract/global_data.dart';


class GeigerIndicatorData extends GlobalData{
  GeigerIndicatorData(this.storageController) : super(storageController);

  final StorageController storageController;


  ///@return Future<GeigerScoreThreats>
  ///@param required path ex: Users:uuid:gi:data:GeigerScoreAggregate
  Future<GeigerScoreThreats> getGeigerScoreThreats({required String path}) async {
  List<ThreatScore> threatsScore = [];
  List<Threat> threats = await _getLimitedThreats();
  late String geigerScore;
    try {

      List<Node> nodes = await storageController
          .search(SearchCriteria(searchPath: path));
      for (Node node in  nodes) {
        //check if node exist
        if (node.parentPath == path) {
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


            //filter
            List<Threat> threat =
                threats.where((Threat element) => element.threatId == threatId).toList();
            for(Threat t in threat){
              ThreatScore ts = ThreatScore(threat: t, score: score);

              //add to threatsScore
              threatsScore.add(ts);
            }


          }


        }
        else {
          log("$path => NODE PATH DOES NOT EXIST");
        }
      }


    }
    on Error catch(e){
      log('Got Exception while fetching data from this $path\n $e');
    }
  return GeigerScoreThreats(
      threatScores: threatsScore, geigerScore: geigerScore);
  }

  //return only phishing and malware
  Future<List<Threat>> _getLimitedThreats()async{
    List<Threat> threats = await getGlobalThreats();
    List<Threat> t = [];
    try{
      //search
      Threat phishing = threats.firstWhere((Threat value) => value.name.toLowerCase().contains("phishing"));
      Threat malware = threats.firstWhere((Threat value) => value.name.toLowerCase().contains("malware") );
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

      List<Node> nodes = await storageController.search(SearchCriteria(searchPath: path));

      for(Node node in nodes){
        if(node.parentPath == path){
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
              List<String> rI = reco.split(",");//split on colon
              String recomId = rI[0];//recomId
              String weight = rI[1];// weight Level
              indicatorRecommendation.add(IndicatorRecommendation(recommendationId: recomId, weight: weight));
            }

          }

        }
        else {
          log("$path => NODE PATH DOES NOT EXIST");
        }
      }

    }
    on Error catch(e){
      log('Got Exception while fetching data from this $path\n $e');
    }
    return indicatorRecommendation;
  }
  
  
  Future<List<GlobalRecommendation>> getGeigerRecommendations({required String path, required String threatId})async{
    List<GlobalRecommendation> r = [];
    List<IndicatorRecommendation> indicatorRecommendations = await _getIndicatorRecommendation(path: path, threatId: threatId);
    List<GlobalRecommendation> globalRecommendation = await getGlobalRecommendations();

    //check if indicatorRecommendation is empty
    if(indicatorRecommendations.isNotEmpty){
      for(IndicatorRecommendation indicatorRecommendation in indicatorRecommendations){

        List<GlobalRecommendation> recommendations = globalRecommendation.where((GlobalRecommendation value) => value.recommendationId == indicatorRecommendation.recommendationId).toList();
        for(GlobalRecommendation recommendation in recommendations){
          r.add(recommendation);
        }

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
