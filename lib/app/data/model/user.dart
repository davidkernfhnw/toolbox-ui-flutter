import 'dart:convert';
import 'package:geiger_toolbox/app/data/model/share_info.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:json_annotation/json_annotation.dart';

import 'consent.dart';
import 'device.dart';
import 'mse.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
//Equatable makes it easy to compare objects
class User {
  String? userId;
  String? userName;
  String language;
  String? country;
  bool supervisor;
  String? cert;
  String? profAss;
  TermsAndConditions termsAndConditions;
  Consent consent;
  Device deviceOwner;
  List<Device>? pairedDevices = <Device>[];
  ShareInfo? shareInfo;
  Mse? mse;

  User(
      {this.userId,
      this.userName,
      this.language: "en",
      this.country,
      this.supervisor: false,
      this.cert,
      this.profAss,
      required this.termsAndConditions,
      required this.consent,
      required this.deviceOwner,
      this.pairedDevices,
      this.shareInfo,
      this.mse});

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }

  //convert from json  to User
  static User convertToUser(String json) {
    var jsonData = jsonDecode(json);
    return User.fromJson(jsonData);
  }

  // convert from User to Json
  static String convertToJson(User user) {
    var jsonData = jsonEncode(user);
    return jsonData;
  }

  @override
  String toString() {
    super.toString();
    return '{"userId":$userId,"userName":$userName, "language":$language, "country":$country, "supervisor":$supervisor,"cert":$cert, "profAss":$profAss, "termsAndConditions":$termsAndConditions, "consent":$consent, "deviceOwner":$deviceOwner, "pairedDevices":$pairedDevices, "shareInfo": $shareInfo, "mse":$mse}';
  }
}
