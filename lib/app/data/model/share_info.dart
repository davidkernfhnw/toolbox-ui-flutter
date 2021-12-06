import 'package:json_annotation/json_annotation.dart';

part 'share_info.g.dart';

@JsonSerializable(explicitToJson: true)
class ShareInfo {
  final String username;
  final String sharedScore;
  final DateTime sharedScoreDate;

  ShareInfo(
      {required this.username,
      required this.sharedScore,
      required this.sharedScoreDate});

  factory ShareInfo.fromJson(Map<String, dynamic> json) {
    return _$ShareInfoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ShareInfoToJson(this);
  }
}
