import 'package:json_annotation/json_annotation.dart';

part 'threat_score.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreatScore {
  String? score;
  ThreatScore(this.score);

  factory ThreatScore.fromJson(Map<String, dynamic> json) {
    return _$ThreatScoreFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatScoreToJson(this);
  }
}
