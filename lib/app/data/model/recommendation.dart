import 'package:json_annotation/json_annotation.dart';

part 'recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class Recommendation {
  String recommendationId;
  String shortDescription;
  String? longDescription;
  String? weight;
  String? action;

  Recommendation({
    required this.recommendationId,
    required this.shortDescription,
    this.longDescription,
    this.weight,
    this.action,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return _$RecommendationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RecommendationToJson(this);
  }

  @override
  String toString() {
    return '{"recommendationID:$recommendationId, shortDescription:$shortDescription,longDescription:$longDescription,  weight:$weight, action:$action}';
  }
}
