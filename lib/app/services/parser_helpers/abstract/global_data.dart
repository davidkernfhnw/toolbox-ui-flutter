import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/global_recommendation.dart';
import 'package:geiger_toolbox/app/model/related_threat_weight.dart';
import 'package:geiger_toolbox/app/model/threat.dart';

abstract class GlobalData {
  GlobalData(this.storageController);

  final StorageController storageController;

  static const String GLOBAL_THREAT_PATH = ":Global:threats";
  static const String GLOBAL_RECOMMENDATION_PATH = ":Global:Recommendations";

  ///@param optional language as string
  ///@return  list of threats from localStorage
  Future<List<Threat>> getGlobalThreats({String locale: "en"}) async {
    List<Threat> t = [];
    try {
      List<Node> nodes = await storageController
          .search(SearchCriteria(searchPath: GLOBAL_THREAT_PATH));

      //return _node!.getChildNodesCsv();
      //print(nodes.toString());
      for (Node node in await nodes) {
        //check if path exist
        //log("${node.parentPath}");
        if (node.parentPath == ":Global") {
          String children = await node.getChildNodesCsv();
          List<String> threatIds = children.split(',');
          for (String threatId in threatIds) {
            Node threatNode =
                await storageController.get("$GLOBAL_THREAT_PATH:$threatId");

            t.add(Threat(
                threatId: await threatId,
                name: await threatNode
                    .getValue("name")
                    .then((value) => value!.getValue(locale)!)));
          }
        }
        // else {
        //   print("$GLOBAL_THREAT_PATH => NODE PATH DOES NOT EXIST");
        // }
      }
    } catch (e) {
      log('Got Exception while fetching list of threats: $e');
    }
    return t;
  }

  Future<List<GlobalRecommendation>> getGlobalRecommendations(
      {String locale: "en"}) async {
    List<GlobalRecommendation> r = [];
    List<RelatedThreatWeight> tW = [];
    String longDescription = "";
    String action = "";
    try {
      List<Node> nodes = await storageController
          .search(SearchCriteria(searchPath: GLOBAL_RECOMMENDATION_PATH));
      // Node node = await storageController.get(GLOBAL_RECOMMENDATION_PATH);
      // log("Global Recommendation => $node");
      for (Node node in await nodes) {
        //check first path exist
        if (node.parentPath == ":Global") {
          String children = await node.getChildNodesCsv();

          List<String> recommendationIds = children.split(',');
          //check if path exist
          for (String recommendationId in recommendationIds) {
            Node recommendationNode = await storageController
                .get("$GLOBAL_RECOMMENDATION_PATH:$recommendationId");
            //log("Global Recommendation ==> ${recommendationNode}");
            String shortDescription = await recommendationNode
                .getValue("short")
                .then((value) => value!.getValue(locale)!);
            NodeValue? long = await recommendationNode.getValue("long");
            if (long != null) {
              longDescription = long.getValue(locale)!;
            }
            NodeValue? a = await recommendationNode.getValue("action");
            if (a != null) {
              action = a.getValue(locale)!;
            }

            String recommendationType = await recommendationNode
                .getValue("RecommendationType")
                .then((value) => value!.getValue(locale)!);

            //relatedThreats is separated by , and ;
            String relatedThreats = await recommendationNode
                .getValue("relatedThreatsWeights")
                .then((value) => value!.getValue(locale)!);

            List<String> relThreatsWeight =
                relatedThreats.split(";"); //split on semi-colon
            //log("Global recommendation: $relThreatsWeight");

            for (String relThreatWeight in relThreatsWeight) {
              List<String> tw = relThreatWeight.split(",");
              String threatId = tw[0];
              String threatWeight = tw[1];

              List<Threat> threats = await getGlobalThreats();

              List<Threat> threat = threats
                  .where(
                      (Threat element) => element.threatId.contains(threatId))
                  .toList();

              for (Threat t in threat) {
                RelatedThreatWeight relatedThreatWeight =
                    RelatedThreatWeight(threat: t, threatWeight: threatWeight);
                //to list of RelatedThreatWeight
                tW.add(relatedThreatWeight);
              }
            }

            r.add(GlobalRecommendation(
                recommendationId: recommendationId,
                shortDescription: shortDescription,
                longDescription: longDescription,
                recommendationType: recommendationType,
                relatedThreatsWeights: tW,
                action: action));
          }
        }
        // else {
        //   log("$GLOBAL_RECOMMENDATION_PATH => NODE PATH DOES NOT EXIST");
        // }
      }
    } on Error catch (e, s) {
      log('Got Exception while fetching list of global recommendation: $e \n $s');
    }
    return r;
  }

  //return only phishing and malware
  Future<List<Threat>> getLimitedThreats() async {
    List<Threat> threats = await getGlobalThreats();
    List<Threat> t = [];
    try {
      //search
      Threat phishing = threats.firstWhere(
          (Threat value) => value.name.toLowerCase().contains("phishing"));
      Threat malware = threats.firstWhere(
          (Threat value) => value.name.toLowerCase().contains("malware"));
      t.add(phishing);
      t.add(malware);
    } catch (e) {
      log("Phishing and malware not found in the database");
    }

    return t;
  }
}
