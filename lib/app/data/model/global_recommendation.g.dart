// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalRecommendation _$GlobalRecommendationFromJson(
        Map<String, dynamic> json) =>
    GlobalRecommendation(
      recommendationId: json['recommendationId'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String?,
      action: json['action'] as String?,
      relatedThreatsWeights: (json['relatedThreatsWeights'] as List<dynamic>)
          .map((e) => RelatedThreatWeight.fromJson(e as Map<String, dynamic>))
          .toList(),
      costs: json['costs'] as String?,
      recommendationType: json['recommendationType'] as String,
    );

Map<String, dynamic> _$GlobalRecommendationToJson(
        GlobalRecommendation instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'action': instance.action,
      'relatedThreatsWeights':
          instance.relatedThreatsWeights.map((e) => e.toJson()).toList(),
      'costs': instance.costs,
      'recommendationType': instance.recommendationType,
    };
