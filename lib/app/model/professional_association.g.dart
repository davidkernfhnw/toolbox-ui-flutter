// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_association.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalAssociation _$ProfessionalAssociationFromJson(
        Map<String, dynamic> json) =>
    ProfessionalAssociation(
      id: json['id'] as String?,
      name: json['name'] as String?,
      locationId: json['locationId'] as String?,
    );

Map<String, dynamic> _$ProfessionalAssociationToJson(
        ProfessionalAssociation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'locationId': instance.locationId,
    };
