// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    Recommendation(
      recommendationId: json['recommendationId'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String?,
      recommendationType: json['recommendationType'] as String,
      weight: json['weight'] as String?,
      action: json['action'] as String?,
      implemented: json['implemented'] as bool? ?? false,
    );

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'recommendationType': instance.recommendationType,
      'weight': instance.weight,
      'action': instance.action,
      'implemented': instance.implemented,
    };
