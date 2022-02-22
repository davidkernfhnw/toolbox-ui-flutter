// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cert _$CertFromJson(Map<String, dynamic> json) => Cert(
      id: json['id'] as String?,
      name: json['name'] as String?,
      locationId: json['locationId'] as String?,
    );

Map<String, dynamic> _$CertToJson(Cert instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'locationId': instance.locationId,
    };
