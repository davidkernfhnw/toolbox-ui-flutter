// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geiger_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeigerRecommendation _$GeigerRecommendationFromJson(Map<String, dynamic> json) {
  return GeigerRecommendation(
    Threat.fromJson(json['threatId'] as Map<String, dynamic>),
    (json['recommendations'] as List<dynamic>)
        .map((e) => (e as Map<String, dynamic>).map(
              (k, e) => MapEntry(
                  k, Recommendation.fromJson(e as Map<String, dynamic>)),
            ))
        .toList(),
  );
}

Map<String, dynamic> _$GeigerRecommendationToJson(
        GeigerRecommendation instance) =>
    <String, dynamic>{
      'threatId': instance.threatId.toJson(),
      'recommendations': instance.recommendations
          .map((e) => e.map((k, e) => MapEntry(k, e.toJson())))
          .toList(),
    };
