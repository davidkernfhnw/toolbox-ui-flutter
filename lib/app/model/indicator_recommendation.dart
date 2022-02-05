import 'package:json_annotation/json_annotation.dart';

part 'indicator_recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class IndicatorRecommendation {
  final String recommendationId;
  final String weight;

  IndicatorRecommendation(
      {required this.recommendationId, required this.weight});
  factory IndicatorRecommendation.fromJson(Map<String, dynamic> json) {
    return _$IndicatorRecommendationFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$IndicatorRecommendationToJson(this);
  }
}
