// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Threat _$ThreatFromJson(Map<String, dynamic> json) => Threat(
      json['threatId'] as String?,
      json['name'] as String?,
      json['score'] == null
          ? null
          : Score.fromJson(json['score'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThreatToJson(Threat instance) => <String, dynamic>{
      'threatId': instance.threatId,
      'name': instance.name,
      'score': instance.score?.toJson(),
    };
