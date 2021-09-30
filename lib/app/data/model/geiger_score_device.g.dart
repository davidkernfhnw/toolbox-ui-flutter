// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geiger_score_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeigerScoreDevice _$GeigerScoreDeviceFromJson(Map<String, dynamic> json) =>
    GeigerScoreDevice(
      Device.fromJson(json['deviceId'] as Map<String, dynamic>),
      json['geigerScore'] as String,
      (json['threatScore'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).map(
                (k, e) =>
                    MapEntry(k, Threat.fromJson(e as Map<String, dynamic>)),
              ))
          .toList(),
    );

Map<String, dynamic> _$GeigerScoreDeviceToJson(GeigerScoreDevice instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId.toJson(),
      'geigerScore': instance.geigerScore,
      'threatScore': instance.threatScore
          .map((e) => e.map((k, e) => MapEntry(k, e.toJson())))
          .toList(),
    };
