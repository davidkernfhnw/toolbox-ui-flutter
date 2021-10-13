import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable(explicitToJson: true)
class Device {
  String deviceId;
  String deviceName;
  String? os;
  String? osVersion;
  User owner;

  Device(this.deviceId, this.deviceName, this.os, this.osVersion, this.owner);

  factory Device.fromJson(Map<String, dynamic> json) {
    return _$DeviceFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeviceToJson(this);
  }
}
