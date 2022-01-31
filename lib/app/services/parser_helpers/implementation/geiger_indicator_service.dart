import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/data/model/global_recommendation.dart';
import 'package:geiger_toolbox/app/data/model/indicator_recommendation.dart';
import 'package:geiger_toolbox/app/data/model/recommendation.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/data/model/threat_score.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/abstract/global_data.dart';


class GeigerIndicatorService extends GlobalData {
  GeigerIndicatorService(this.storageController) : super(storageController);

  final StorageController storageController;


  ///@return Future<GeigerScoreThreats>
  ///@param required path ex: Users:uuid:gi:data:GeigerScoreAggregate
  Future<GeigerScoreThreats> getGeigerScoreThreats(
      {required String path}) async {
    List<ThreatScore> threatsScore = [];
    List<Threat> threats = await getLimitedThreats();
    String geigerScore = "";
    try {
      Node node = await storageController.get(path);
      log(node.toString());
      List<Node> nodes = await storageController
          .search(SearchCriteria(searchPath: path));
      for (Node node in nodes) {
        //check if node exist
        //Todo : test this
        if (node.path == path) {
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

          log(splitThreatScores.toString());


          for (String splitThreatScore in splitThreatScores) {
            List<String> tS = splitThreatScore.split(",");


            //log(splitThreatScore.toString());
            if (splitThreatScore.isNotEmpty) {
              String threatId = tS[0];
              String score = tS[1];
              //log(tS.isEmpty.toString());


              //filter
              List<Threat> threat =
              threats.where((Threat element) => element.threatId == threatId)
                  .toList();
              for (Threat t in threat) {
                ThreatScore ts = ThreatScore(threat: t, score: score);

                //add to threatsScore
                threatsScore.add(ts);
              }
            }
          }
        }
        else {
          log("$path => NODE PATH NOT FOUND");
        }
      }
    }
    on Error catch (e, s) {
      log('Got Exception while fetching data from this $path\n $e\n $s');
    }
    return GeigerScoreThreats(
        threatScores: threatsScore, geigerScore: geigerScore);
  }


  ///@param String node path,@param String threatId
  ///@ return Future<List<IndicatorRecommendation>>
  Future<List<IndicatorRecommendation>> _getIndicatorRecommendation(
      {required String nodePath, required String threatId}) async {
    List<IndicatorRecommendation> indicatorRecommendation = [];
    try {
      List<Node> nodes = await storageController.search(
          SearchCriteria(searchPath: nodePath));

      for (Node node in nodes) {
        if (node.path == nodePath) {
          NodeValue? nodeValueI = await storageController.getValue(
              nodePath, threatId);
          if(nodeValueI != null){
            String reco = nodeValueI.value;
            //check if empty
            if (reco.isEmpty) {
              // return empty list
              return [];
            }
            List<String> recoSplit = reco.split(";"); //split on semi-colon
            log("indicatorRecommendation: $recoSplit");

            for (String reco in recoSplit) {
              if (reco.isNotEmpty) {
                List<String> rI = reco.split(","); //split on colon
                String recomId = rI[0]; //recomId
                String weight = rI[1]; // weight Level

                indicatorRecommendation.add(IndicatorRecommendation(
                    recommendationId: recomId, weight: weight));
              }
            }
          }

        }
        else {
          log("$nodePath => NODE PATH NOT FOUND");
        }
      }
    }
    on Error catch (e,s) {
      log('Got Exception while fetching data from this $nodePath\n $e\n $s');
    }
    return indicatorRecommendation;
  }

  ///@param String node geigerScoreNodepath
  ///@return Future<List<String>>
  Future<List<String>> _getImplementedRecommendationId(
      {required String geigerScoreNodePath}) async {
    List<String> implRecom = [];
    String key = "implementedRecommendations";
    NodeValue? nodeValue = await storageController.getValue(
        geigerScoreNodePath, key);
    String? existImplRecom = nodeValue?.value;
    if (existImplRecom != "" && existImplRecom != null) {
      List<String> implRecos = existImplRecom.split(",");
      for (String i in implRecos) {
        implRecom.add(i);
      }
    }
    log("Implemented recommendation ==> $implRecom");
    return implRecom;
  }

  ///List<IndicatorRecommendation> indicationRecommendation is a subset
  ///of List<GlobalRecommendation>globalRecommendation
  ///List<String> implementedRecommendation is of list of recommendationIds
  Future<List<Recommendation>> getGeigerRecommendations(
      {required String recommendationPath,
        required String threatId,
        required geigerScorePath}) async {
    List<Recommendation> finalRecommendations = [];
    List<IndicatorRecommendation> indicatorRecommendations =
    await _getIndicatorRecommendation(
        nodePath: recommendationPath, threatId: threatId);
    List<GlobalRecommendation> globalRecommendations =
    await getGlobalRecommendations();
    List<String> implementedRecommendationIds =

    await _getImplementedRecommendationId(geigerScoreNodePath: geigerScorePath);

    //check if indicatorRecommendation is empty then return empty list
    if (indicatorRecommendations.isEmpty) return [];

    // there are some indicator recommendations
    for (IndicatorRecommendation indicatorRecommendation
    in indicatorRecommendations) {
      //filter globalRecommendation using indicatorRecommendation
      List<GlobalRecommendation> globalIndicatorRecommendations =
      globalRecommendations
          .where((GlobalRecommendation value) =>
      value.recommendationId ==
          indicatorRecommendation.recommendationId)
          .toList();

      for (GlobalRecommendation gRecommendation
      in globalIndicatorRecommendations) {
        // Check if the recommendation has been implemented
        final bool isImplemented =
        implementedRecommendationIds.contains(gRecommendation.recommendationId);

        Recommendation fG = Recommendation(
            recommendationId: gRecommendation.recommendationId,
            weight: indicatorRecommendation.weight,
            shortDescription: gRecommendation.shortDescription,
            longDescription: gRecommendation.longDescription,
            action: gRecommendation.action,
            recommendationType: gRecommendation.recommendationType,
            implemented: isImplemented,
            disableActionButton: isImplemented);
        finalRecommendations.add(fG);
      }
    }
    return finalRecommendations;
  }
}
