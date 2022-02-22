import 'dart:convert';

import 'package:geiger_toolbox/app/model/tool.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable(explicitToJson: true)
class Device {
  String? deviceId;

  String? name;
  String? type;
  List<Tool>? tools;

  Device({this.deviceId, this.name, this.type, this.tools});

  factory Device.fromJson(Map<String, dynamic> json) {
    return _$DeviceFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeviceToJson(this);
  }

  //convert from Json to Device
  static Device convertToDevice(String json) {
    var jsonData = jsonDecode(json);
    return Device.fromJson(jsonData);
  }

  // convert from Device to json
  static String convertToJson(Device currentDevice) {
    var jsonData = jsonEncode(currentDevice);
    return jsonData;
  }

  @override
  String toString() {
    super.toString();
    return '{"deviceId":$deviceId,  "name":$name, "type":$type, "tools":$tools}';
  }
}
