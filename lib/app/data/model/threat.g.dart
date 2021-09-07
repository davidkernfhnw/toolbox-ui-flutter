// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Threat _$ThreatFromJson(Map<String, dynamic> json) {
  return Threat(
    json['threatId'] as String,
    json['name'] as String,
  );
}

Map<String, dynamic> _$ThreatToJson(Threat instance) => <String, dynamic>{
      'threatId': instance.threatId,
      'name': instance.name,
    };
