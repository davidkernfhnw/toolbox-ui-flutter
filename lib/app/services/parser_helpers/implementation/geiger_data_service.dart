import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/geiger_score_threats.dart';
import 'package:geiger_toolbox/app/model/global_recommendation.dart';
import 'package:geiger_toolbox/app/model/indicator_recommendation.dart';
import 'package:geiger_toolbox/app/model/recommendation.dart';
import 'package:geiger_toolbox/app/model/threat.dart';
import 'package:geiger_toolbox/app/model/threat_score.dart';
import 'package:geiger_toolbox/app/model/tool.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/abstract/global_data_abstract.dart';

const String _LOCAL_PLUGIN = ":Local:plugin";
const String _APP_NAME_KEY = "appname";
const String _COMPANY_KEY = "company";

class GeigerDataService extends GlobalDataAbstract {
  GeigerDataService(this.storageController) : super(storageController);

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
      List<Node> nodes =
          await storageController.search(SearchCriteria(searchPath: path));
      for (Node node in nodes) {
        //check if node exist
        //Todo : test this
        if (node.path == path) {
          NodeValue? nodeValueG =
              await storageController.getValue(path, "GEIGER_score");

          geigerScore = nodeValueG!.value;

          NodeValue? nodeValueT =
              await storageController.getValue(path, "threats_score");

          String threatScore = nodeValueT!.value;

          // split on semi-colon
          List<String> splitThreatScores = threatScore.split(";");

          log(splitThreatScores.toString());

          for (String splitThreatScore in splitThreatScores) {
            List<String> tS = splitThreatScore.split(",");

            //log(splitThreatScore.toString());
            if (splitThreatScore.isNotEmpty) {
              String threatId = tS[0];
              String score = tS[1];
              //log(tS.isEmpty.toString());

              //filter
              List<Threat> threat = threats
                  .where((Threat element) => element.threatId == threatId)
                  .toList();
              for (Threat t in threat) {
                ThreatScore ts = ThreatScore(threat: t, score: score);

                //add to threatsScore
                threatsScore.add(ts);
              }
            }
          }
        } else {
          log("$path => NODE PATH NOT FOUND");
        }
      }
    } on Error catch (e, s) {
      log('Got Exception while fetching data from this $path\n $e\n $s');
    }
    return GeigerScoreThreats(
        threatScores: threatsScore, geigerScore: geigerScore);
  }

  //don't use, it has bug
  // Future<GeigerScoreThreats> showThreatLevel({required String path}) async {
  //   GeigerScoreThreats geigerScoreThreats =
  //       await getGeigerScoreThreats(path: path);
  //   List<GlobalRecommendation> globalRecommendations =
  //       await getGlobalRecommendations();
  //   List<RelatedThreatWeight> relatedThreatWeights = [];
  //
  //   for (GlobalRecommendation globalRecommendation in globalRecommendations) {
  //     relatedThreatWeights = globalRecommendation.relatedThreatsWeights;
  //   }
  //   log("RELATEDTHREATWEIGHTS ==> $relatedThreatWeights");
  //   for (RelatedThreatWeight tw in relatedThreatWeights) {
  //     ThreatScore threatScore = geigerScoreThreats.threatScores.firstWhere(
  //         (element) => element.threat.threatId == tw.threat.threatId);
  //     bool r = geigerScoreThreats.threatScores.contains(threatScore);
  //     if (r) {
  //       geigerScoreThreats.threatLevel = await tw.threatWeight;
  //     }
  //   }
  //   return geigerScoreThreats;
  // }

  ///@param String node path,@param String threatId
  ///@ return Future<List<IndicatorRecommendation>>
  Future<List<IndicatorRecommendation>> _getIndicatorRecommendation(
      {required String nodePath, required String threatId}) async {
    List<IndicatorRecommendation> indicatorRecommendation = [];
    try {
      List<Node> nodes =
          await storageController.search(SearchCriteria(searchPath: nodePath));

      for (Node node in nodes) {
        if (node.path == nodePath) {
          NodeValue? nodeValueI =
              await storageController.getValue(nodePath, threatId);
          if (nodeValueI != null) {
            String reco = nodeValueI.value;
            //check if empty
            if (reco.isEmpty) {
              // return empty list
              return [];
            }
            //split on semi-colon
            List<String> recoSplit = reco.split(";");
            log("indicatorRecommendation: $recoSplit");

            for (String reco in recoSplit) {
              if (reco.isNotEmpty) {
                //split on colon
                List<String> rI = reco.split(",");
                //recomId
                String recomId = rI[0];
                //weight Level
                String weight = rI[1];

                indicatorRecommendation.add(IndicatorRecommendation(
                    recommendationId: recomId, weight: weight));
              }
            }
          }
        } else {
          log("$nodePath => NODE PATH NOT FOUND");
        }
      }
    } on Error catch (e, s) {
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
    NodeValue? nodeValue =
        await storageController.getValue(geigerScoreNodePath, key);
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

  ///@return List<Recommendation> of Global recommendation with implemented field filtered
  ///set either true/false implemented field based on recommendation that was implemented
  Future<List<Recommendation>> getGeigerRecommendations({
    required geigerScorePath,
  }) async {
    List<Recommendation> finalRecommendations = [];
    List<GlobalRecommendation> globalRecommendations =
        await getGlobalRecommendations();
    List<String> implementedRecommendationIds =
        await _getImplementedRecommendationId(
            geigerScoreNodePath: geigerScorePath);

    for (GlobalRecommendation gRecommendation in globalRecommendations) {
      //Check if the recommendation has been implemented
      final bool isImplemented = implementedRecommendationIds
          .contains(gRecommendation.recommendationId);

      Recommendation fG = Recommendation(
        recommendationId: gRecommendation.recommendationId,
        shortDescription: gRecommendation.shortDescription,
        longDescription: gRecommendation.longDescription,
        action: gRecommendation.action,
        recommendationType: gRecommendation.recommendationType,
        implemented: isImplemented,
      );
      finalRecommendations.add(fG);
    }
    // }
    return finalRecommendations;
  }

  ///@return List<Recommendation> recommended by the geiger_indicator
  /// @param List<Recommendation> of global recommendation
  /// @param String recommendationPath
  /// @param String geigerScorePath
  Future<List<Recommendation>> getFilteredRecommendations(
      {required List<Recommendation> gRecommendations,
      required String recommendationPath,
      required String geigerScorePath,
      required String threatId}) async {
    List<Recommendation> filteredRecommendations = [];

    List<IndicatorRecommendation> indicatorRecommendations =
        await _getIndicatorRecommendation(
            nodePath: recommendationPath, threatId: threatId);

    List<String> implementedRecommendationIds =
        await _getImplementedRecommendationId(
            geigerScoreNodePath: geigerScorePath);

    if (indicatorRecommendations.isEmpty) return [];

    //there are some indicator recommendations
    for (IndicatorRecommendation indicatorRecommendation
        in indicatorRecommendations) {
      //filter globalRecommendation using indicatorRecommendation
      Recommendation filteredRecommendation = gRecommendations.firstWhere(
          (Recommendation value) =>
              value.recommendationId ==
              indicatorRecommendation.recommendationId);
      //Check if the recommendation has been implemented
      final bool isImplemented = implementedRecommendationIds
          .contains(indicatorRecommendation.recommendationId);

      Recommendation r = Recommendation(
          recommendationId: filteredRecommendation.recommendationId,
          shortDescription: filteredRecommendation.shortDescription,
          longDescription: filteredRecommendation.longDescription,
          weight: indicatorRecommendation.weight,
          action: filteredRecommendation.action,
          implemented: isImplemented,
          recommendationType: filteredRecommendation.recommendationType);

      filteredRecommendations.add(r);
    }
    return filteredRecommendations;
  }

  Future<List<Tool>> showExternalTools({String locale: "en"}) async {
    List<Tool> tools = [];
    try {
      List<Node> nodes = await storageController
          .search(SearchCriteria(searchPath: _LOCAL_PLUGIN));
      for (Node node in await nodes) {
        //check if path exist
        //log("${node.parentPath}");
        if (node.parentPath == ":Local") {
          String children = await node.getChildNodesCsv();
          List<String> toolIds = children.split(',');
          for (String toolId in toolIds) {
            Node toolNode =
                await storageController.get("$_LOCAL_PLUGIN:$toolId");

            tools.add(Tool(
                toolId: await toolId,
                company: await toolNode
                    .getValue(_COMPANY_KEY)
                    .then((value) => value!.getValue(locale)!),
                appName: await toolNode
                    .getValue(_APP_NAME_KEY)
                    .then((value) => value!.getValue(locale)!)));
          }
        }
      }
    } catch (e) {
      log('Got Exception while fetching list of threats: $e');
    }
    return tools;
  }
}
