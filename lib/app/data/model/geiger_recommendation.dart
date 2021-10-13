import 'package:geiger_toolbox/app/data/model/recommendation.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geiger_recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class GeigerRecommendation {
  Threat threatId;
  List<Map<String, Recommendation>> recommendations = [];

  GeigerRecommendation(this.threatId, this.recommendations);

  factory GeigerRecommendation.fromJson(Map<String, dynamic> json) {
    return _$GeigerRecommendationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GeigerRecommendationToJson(this);
  }
}
