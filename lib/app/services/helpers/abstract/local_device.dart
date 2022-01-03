import 'dart:async';

//import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

abstract class LocalDevice {
  /// @return deviceId as a Future<String>
  /// from the Local node
  Future<String> get getDeviceId;

  /// @param Device object
  /// @return Future<bool>
  /// store in the Local node
  Future<bool> storeDeviceInfo(Device device);

  /// @return Future<Device>
  /// retrieve user from Local node
  Future<Device> get getDeviceInfo;

//void storeGeigerScoreDevice({ Locale? locale,required GeigerScoreThreats geigerScoreThreats });
//void storeGeigerScoreAggregate({ Locale? locale,required GeigerScoreThreats geigerScoreThreats });

// ----- Helpers
  Future<Node> getNode(String path, StorageController storageController) async {
    return await storageController.get(path);
  }
}
