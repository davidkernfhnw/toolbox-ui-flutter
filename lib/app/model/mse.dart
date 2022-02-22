import 'package:geiger_toolbox/app/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mse.g.dart';

@JsonSerializable(explicitToJson: true)
class Mse {
  final String supervisor;
  final List<User> employees;

  Mse({required this.supervisor, required this.employees});

  factory Mse.fromJson(Map<String, dynamic> json) {
    return _$MseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MseToJson(this);
  }
}
