import 'package:json_annotation/json_annotation.dart';

part 'threat.g.dart';

@JsonSerializable()
class Threat {
  final String threatId;
  final String name;

  Threat(this.threatId, this.name);

  /// A necessary factory constructor for creating a new Threat instance
  /// from a map. Pass the map to the generated `_$ThreatFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Threat.fromJson(Map<String, dynamic> json) {
    return _$ThreatFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ThreatToJson(this);
  }

  @override
  String toString() {
    return "Threat{threatId: $threatId, name: $name }";
  }
}
