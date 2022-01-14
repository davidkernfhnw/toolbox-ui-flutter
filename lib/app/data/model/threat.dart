import 'package:json_annotation/json_annotation.dart';

part 'threat.g.dart';

@JsonSerializable(explicitToJson: true)
class Threat {
  final String threatId;
  final String name;

  Threat({required this.threatId, required this.name});

  factory Threat.fromJson(Map<String, dynamic> map) {
    return _$ThreatFromJson(map);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatToJson(this);
  }

  @override
  String toString() {
    return '{"threatId:$threatId",name:$name}';
  }
}
