// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geiger_aggregate_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeigerAggregateScore _$GeigerAggregateScoreFromJson(Map<String, dynamic> json) {
  return GeigerAggregateScore(
    (json['threatScores'] as List<dynamic>)
        .map((e) => Threat.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['numberMetrics'] as String?,
    json['geigerScore'] as String?,
  );
}

Map<String, dynamic> _$GeigerAggregateScoreToJson(
        GeigerAggregateScore instance) =>
    <String, dynamic>{
      'threatScores': instance.threatScores.map((e) => e.toJson()).toList(),
      'numberMetrics': instance.numberMetrics,
      'geigerScore': instance.geigerScore,
    };
