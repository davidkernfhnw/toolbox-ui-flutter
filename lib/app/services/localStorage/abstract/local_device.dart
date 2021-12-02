import 'dart:async';

//import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

abstract class LocalDevice {
  Future<String> get getDeviceId;

  void set setDeviceInfo(Device device);

  Future<Device> get getDeviceInfo;

//void storeGeigerScoreAggregate({ Locale? locale,required GeigerScoreThreats geigerScoreThreats });

// ----- Helpers
  Future<Node> getNode(String path, StorageController storageController) async {
    return await storageController.get(path);
  }
}
