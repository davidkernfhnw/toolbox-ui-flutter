import 'package:json_annotation/json_annotation.dart';

part 'tool.g.dart';

@JsonSerializable(explicitToJson: true)
class Tool {
  String toolId;
  String appName;
  String company;

  Tool({required this.toolId, required this.appName, required this.company});

  factory Tool.fromJson(Map<String, dynamic> json) {
    return _$ToolFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ToolToJson(this);
  }
}
