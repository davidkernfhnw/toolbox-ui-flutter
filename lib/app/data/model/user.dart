import 'package:geiger_toolbox/app/data/model/role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String userId;

  @JsonKey(defaultValue: "currentUser")
  final String? firstName;

  @JsonKey(defaultValue: "currentUser")
  final String? lastname;

  @JsonKey(defaultValue: "1")
  final String? knowledgeLevel;

  Role? role;
  User(
      {required this.userId,
      this.firstName,
      this.lastname,
      this.knowledgeLevel,
      this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }
}
