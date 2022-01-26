// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indicator_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndicatorRecommendation _$IndicatorRecommendationFromJson(
        Map<String, dynamic> json) =>
    IndicatorRecommendation(
      recommendationId: json['recommendationId'] as String,
      weight: json['weight'] as String,
    );

Map<String, dynamic> _$IndicatorRecommendationToJson(
        IndicatorRecommendation instance) =>
    <String, dynamic>{
      'recommendationId': instance.recommendationId,
      'weight': instance.weight,
    };
