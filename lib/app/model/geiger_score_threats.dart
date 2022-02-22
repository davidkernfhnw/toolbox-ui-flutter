import 'package:geiger_toolbox/app/model/threat_score.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geiger_score_threats.g.dart';

@JsonSerializable(explicitToJson: true)
class GeigerScoreThreats {
  List<ThreatScore> threatScores;
  String geigerScore;
  String? threatLevel;

  GeigerScoreThreats(
      {required this.threatScores,
      required this.geigerScore,
      this.threatLevel});

  factory GeigerScoreThreats.fromJson(Map<String, dynamic> json) {
    return _$GeigerScoreThreatsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GeigerScoreThreatsToJson(this);
  }

  @override
  String toString() {
    return '{threatScore:$threatScores, geigerScore:$geigerScore, threatLevel:$threatLevel}';
  }
}
