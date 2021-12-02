import 'dart:async';

//import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/device.dart';

abstract class LocalDevice {
  Future<String> get getDeviceId;

  void set setDeviceInfo(Device device);

  Future<Device> get getDeviceInfo;

//void storeGeigerScoreAggregate({ Locale? locale,required GeigerScoreThreats geigerScoreThreats });

}
