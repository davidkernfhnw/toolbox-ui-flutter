// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geiger_score_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeigerScore _$GeigerScoreFromJson(Map<String, dynamic> json) => GeigerScore(
      User.fromJson(json['userId'] as Map<String, dynamic>),
      (json['threatScores'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).map(
                (k, e) =>
                    MapEntry(k, Threat.fromJson(e as Map<String, dynamic>)),
              ))
          .toList(),
      json['geigerScore'] as String,
    );

Map<String, dynamic> _$GeigerScoreToJson(GeigerScore instance) =>
    <String, dynamic>{
      'userId': instance.userId.toJson(),
      'threatScores': instance.threatScores
          .map((e) => e.map((k, e) => MapEntry(k, e.toJson())))
          .toList(),
      'geigerScore': instance.geigerScore,
    };
