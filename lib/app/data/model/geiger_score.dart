import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geiger_score.g.dart';

@JsonSerializable(explicitToJson: true)
class GeigerScore {
  User userId;
  Map<String, Threat> threatScores;
  final String geigerScore;

  GeigerScore(this.userId, this.threatScores, this.geigerScore);

  factory GeigerScore.fromJson(Map<String, dynamic> json) {
    return _$GeigerScoreFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GeigerScoreToJson(this);
  }
}
