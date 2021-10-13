import 'package:json_annotation/json_annotation.dart';

part 'score.g.dart';

@JsonSerializable(explicitToJson: true)
class Score {
  String? score;
  Score(this.score);

  factory Score.fromJson(Map<String, dynamic> json) {
    return _$ScoreFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ScoreToJson(this);
  }
}
