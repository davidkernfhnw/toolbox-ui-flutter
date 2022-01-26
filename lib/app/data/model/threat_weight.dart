import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:json_annotation/json_annotation.dart';

part 'threat_weight.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatWeight {
  final Threat threat;
  final String weight;

  ThreatWeight({required this.threat, required this.weight});

  factory ThreatWeight.fromJson(Map<String, dynamic> json) {
    return _$ThreatWeightFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatWeightToJson(this);
  }
}
