import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class Recommendation {
  String recommendationId;
  String shortDescription;
  String longDescription;
  Map<String, Threat> threatImpact;
  User user;
  String recommendationType;

  Recommendation(
      this.recommendationId,
      this.shortDescription,
      this.longDescription,
      this.threatImpact,
      this.user,
      this.recommendationType);

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return _$RecommendationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RecommendationToJson(this);
  }
}
