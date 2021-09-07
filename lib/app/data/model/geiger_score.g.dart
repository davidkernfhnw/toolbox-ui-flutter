// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geiger_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeigerScore _$GeigerScoreFromJson(Map<String, dynamic> json) {
  return GeigerScore(
    User.fromJson(json['userId'] as Map<String, dynamic>),
    (json['threatScores'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, Threat.fromJson(e as Map<String, dynamic>)),
    ),
    json['geigerScore'] as String,
  );
}

Map<String, dynamic> _$GeigerScoreToJson(GeigerScore instance) =>
    <String, dynamic>{
      'userId': instance.userId.toJson(),
      'threatScores':
          instance.threatScores.map((k, e) => MapEntry(k, e.toJson())),
      'geigerScore': instance.geigerScore,
    };
