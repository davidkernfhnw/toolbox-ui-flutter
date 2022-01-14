import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:json_annotation/json_annotation.dart';

part 'threat_score.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatScore {
  final Threat threat;
  final String score;
  ThreatScore({required this.threat, required this.score});

  factory ThreatScore.fromJson(Map<String, dynamic> json) {
    return _$ThreatScoreFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatScoreToJson(this);
  }

  @override
  String toString() {
    return "{threat:$threat, score:$score}";
  }
}
