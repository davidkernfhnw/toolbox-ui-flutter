import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class Recommendation {
  String recommendationId;
  String shortDescription;
  String? longDescription;
  String recommendationType;

  String? weight;
  String? action;
  bool implemented;

  Recommendation({
    required this.recommendationId,
    required this.shortDescription,
    this.longDescription,
    required this.recommendationType,
    this.weight: null,
    this.action: null,
    this.implemented: false,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return _$RecommendationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RecommendationToJson(this);
  }

  static List<Recommendation> recommendationList(String recommendationJson) {
    List<dynamic> jsonData = jsonDecode(recommendationJson);
    return jsonData
        .map((recommendationMap) => Recommendation.fromJson(recommendationMap))
        .toList();
  }

  @override
  String toString() {
    return '{"recommendationID:$recommendationId, shortDescription:$shortDescription,longDescription:$longDescription, recommendationType:$recommendationType weight:$weight, action:$action, implemented:$implemented}';
  }
}
