import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:json_annotation/json_annotation.dart';
part 'geiger_aggregate_score.g.dart';

@JsonSerializable(explicitToJson: true)
class GeigerAggregateScore {
  List<Threat> threatScores;
  String? numberMetrics;
  String? geigerScore;
  GeigerAggregateScore(this.threatScores, this.numberMetrics, this.geigerScore);

  factory GeigerAggregateScore.fromJson(Map<String, dynamic> json) {
    return _$GeigerAggregateScoreFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$GeigerAggregateScoreToJson(this);
  }
}
