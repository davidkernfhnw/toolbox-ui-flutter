import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/global_recommendation.dart';
import 'package:geiger_toolbox/app/data/model/related_threat_weight.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';

abstract class GlobalNode {
  GlobalNode(this.storageController);

  final StorageController storageController;

  static const String GLOBAL_THREAT_PATH = ":Global:threats";
  static const String GLOBAL_RECOMMENDATION_PATH = "Global:Recommendations";

  ///@param optional language as string
  ///@return  list of threats from localStorage
  Future<List<Threat>> getGlobalThreats({String locale: "en"}) async {
    Node node;
    List<Threat> t = [];
    try {
      node = await storageController.get(GLOBAL_THREAT_PATH);

      //return _node!.getChildNodesCsv();
      for (String threatId
          in await node.getChildNodesCsv().then((value) => value.split(','))) {
        Node threatNode =
            await storageController.get("$GLOBAL_THREAT_PATH:$threatId");

        t.add(Threat(
            threatId: threatId,
            name: await threatNode
                .getValue("name")
                .then((value) => value!.getValue(locale)!)));
      }
    } on StorageException {
      rethrow;
    }
    return t;
  }

  Future<List<GlobalRecommendation>> getGlobalRecommendations(
      {String locale: "en"}) async {
    Node node;
    List<GlobalRecommendation> r = [];
    List<RelatedThreatWeight> tW = [];
    try {
      node = await storageController.get(GLOBAL_RECOMMENDATION_PATH);

      //return _node!.getChildNodesCsv();
      for (String recommendationId
          in await node.getChildNodesCsv().then((value) => value.split(','))) {
        Node recommendationNode = await storageController
            .get("$GLOBAL_RECOMMENDATION_PATH:$recommendationId");
        String shortDescription = await recommendationNode
            .getValue("short")
            .then((value) => value!.getValue(locale)!);
        String longDescription = await recommendationNode
            .getValue("long")
            .then((value) => value!.getValue(locale)!);
        String action = await recommendationNode
            .getValue("action")
            .then((value) => value!.getValue(locale)!);

        String recommendationType = await recommendationNode
            .getValue("recommendationType")
            .then((value) => value!.getValue(locale)!);

        //relatedThreats is separated by , and ;
        String relatedThreats = await recommendationNode
            .getValue("relatedThreatsWeights")
            .then((value) => value!.getValue(locale)!);

        List<String> relThreatsWeight =
            relatedThreats.split(";"); //split on semi-colon
        log("Global recommendation: $relThreatsWeight");

        for (String relThreatWeight in relThreatsWeight) {
          List<String> tw = relThreatWeight.split(",");
          String threatId = tw[0];
          String threatWeight = tw[1];

          List<Threat> threats = await getGlobalThreats();

          //filter
          Threat threat = threats
              .where((Threat element) => element.threatId == threatId)
              .toList()
              .first;
          RelatedThreatWeight relatedThreatWeight =
              RelatedThreatWeight(threat: threat, threatWeight: threatWeight);
          //to list of RelatedThreatWeight
          tW.add(relatedThreatWeight);
        }

        r.add(GlobalRecommendation(
            recommendationId: recommendationId,
            shortDescription: shortDescription,
            longDescription: longDescription,
            recommendationType: recommendationType,
            relatedThreatsWeights: tW,
            action: action));
      }
    } on StorageException {
      rethrow;
    }
    return r;
  }
}
