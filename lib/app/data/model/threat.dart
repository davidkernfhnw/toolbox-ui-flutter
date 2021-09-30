import 'package:json_annotation/json_annotation.dart';
import 'package:geiger_toolbox/app/data/model/score.dart';
part 'threat.g.dart';

@JsonSerializable(explicitToJson: true)
class Threat {
  final String? threatId;
  final String? name;
  final Score? score;

  Threat(this.threatId, this.name, this.score);

  /// A necessary factory constructor for creating a new Threat instance
  /// from a map. Pass the map to the generated `_$ThreatFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Threat.
  factory Threat.fromJson(Map<String, dynamic> json) {
    return _$ThreatFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatToJson(this);
  }
}
