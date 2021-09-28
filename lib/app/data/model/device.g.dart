// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) {
  return Device(
    json['deviceId'] as String,
    json['deviceName'] as String,
    json['os'] as String?,
    json['osVersion'] as String?,
    User.fromJson(json['owner'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'os': instance.os,
      'osVersion': instance.osVersion,
      'owner': instance.owner.toJson(),
    };
