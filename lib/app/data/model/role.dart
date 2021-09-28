import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonSerializable(explicitToJson: true)
class Role {
  final String id;

  @JsonKey(defaultValue: "employee")
  final String? name;

  Role({required this.id, this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return _$RoleFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RoleToJson(this);
  }
}
