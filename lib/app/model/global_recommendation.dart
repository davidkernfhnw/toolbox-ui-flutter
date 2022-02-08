import 'package:geiger_toolbox/app/model/related_threat_weight.dart';
import 'package:json_annotation/json_annotation.dart';

part 'global_recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class GlobalRecommendation {
  String recommendationId;
  String shortDescription;
  String? longDescription;
  String? action;
  List<RelatedThreatWeight> relatedThreatsWeights;
  String? costs;
  String recommendationType;

  GlobalRecommendation(
      {required this.recommendationId,
      required this.shortDescription,
      this.longDescription: null,
      this.action: null,
      required this.relatedThreatsWeights,
      this.costs: null,
      required this.recommendationType});

  factory GlobalRecommendation.fromJson(Map<String, dynamic> json) {
    return _$GlobalRecommendationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GlobalRecommendationToJson(this);
  }

  @override
  String toString() {
    return '{recommendationID:$recommendationId, shortDescription:$shortDescription,longDescription:$longDescription, action:$action, relatedThreatsWeights:$relatedThreatsWeights, recommendationType:$recommendationType}';
  }
}
