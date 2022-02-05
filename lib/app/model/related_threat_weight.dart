import 'package:geiger_toolbox/app/model/threat.dart';
import 'package:json_annotation/json_annotation.dart';

part 'related_threat_weight.g.dart';

@JsonSerializable(explicitToJson: true)
class RelatedThreatWeight {
  Threat threat;
  String threatWeight;

  RelatedThreatWeight({required this.threat, required this.threatWeight});

  factory RelatedThreatWeight.fromJson(Map<String, dynamic> map) {
    return _$RelatedThreatWeightFromJson(map);
  }

  Map<String, dynamic> toJson() {
    return _$RelatedThreatWeightToJson(this);
  }

  @override
  String toString() {
    return '{"threat:$threat, threatWeight:$threatWeight"}';
  }
}
