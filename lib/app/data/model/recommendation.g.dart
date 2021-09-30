// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    Recommendation(
      json['recommendationId'] as String,
      json['shortDescription'] as String,
      json['longDescription'] as String,
      (json['threatImpact'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Threat.fromJson(e as Map<String, dynamic>)),
      ),
      User.fromJson(json['user'] as Map<String, dynamic>),
      json['recommendationType'] as String,
    );

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'threatImpact':
          instance.threatImpact.map((k, e) => MapEntry(k, e.toJson())),
      'user': instance.user.toJson(),
      'recommendationType': instance.recommendationType,
    };
