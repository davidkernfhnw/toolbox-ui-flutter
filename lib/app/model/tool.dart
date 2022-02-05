import 'package:json_annotation/json_annotation.dart';

part 'tool.g.dart';

@JsonSerializable(explicitToJson: true)
class Tool {
  String? toolId;
  String? name;

  Tool({String? toolId, required this.name});

  factory Tool.fromJson(Map<String, dynamic> json) {
    return _$ToolFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ToolToJson(this);
  }
}
