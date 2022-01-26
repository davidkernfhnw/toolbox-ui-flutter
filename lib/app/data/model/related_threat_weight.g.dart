// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'related_threat_weight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatedThreatWeight _$RelatedThreatWeightFromJson(Map<String, dynamic> json) =>
    RelatedThreatWeight(
      threat: Threat.fromJson(json['threat'] as Map<String, dynamic>),
      threatWeight: json['threatWeight'] as String,
    );

Map<String, dynamic> _$RelatedThreatWeightToJson(
        RelatedThreatWeight instance) =>
    <String, dynamic>{
      'threat': instance.threat.toJson(),
      'threatWeight': instance.threatWeight,
    };
