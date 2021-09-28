import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:json_annotation/json_annotation.dart';

import 'device.dart';
part 'geiger_score_device.g.dart';

@JsonSerializable(explicitToJson: true)
class GeigerScoreDevice {
  Device deviceId;
  String geigerScore;
  List<Map<String, Threat>> threatScore = [];

  GeigerScoreDevice(this.deviceId, this.geigerScore, this.threatScore);

  factory GeigerScoreDevice.fromJson(Map<String, dynamic> json) {
    return _$GeigerScoreDeviceFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GeigerScoreDeviceToJson(this);
  }
}
