// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geiger_score_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeigerScoreDevice _$GeigerScoreDeviceFromJson(Map<String, dynamic> json) =>
    GeigerScoreDevice(
      Device.fromJson(json['deviceId'] as Map<String, dynamic>),
      json['geigerScore'] as String,
      (json['threatScores'] as List<dynamic>)
          .map((e) => Threat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GeigerScoreDeviceToJson(GeigerScoreDevice instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId.toJson(),
      'geigerScore': instance.geigerScore,
      'threatScores': instance.threatScores.map((e) => e.toJson()).toList(),
    };
