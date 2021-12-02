import 'dart:async';

//import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

abstract class LocalUser {
  Future<String> get getUserId;

  Future<void> storeUserInfo(User user);

  Future<User> get getUserInfo;

  Future<bool> storeTermsAndConditions(
      {required TermsAndConditions termsAndConditions,
      required User userInfo,
      required Device deviceInfo});
  //void storeGeigerScoreAggregate({ Locale? locale,required GeigerScoreThreats geigerScoreThreats });

// ----- Helpers
  Future<Node> getNode(String path, StorageController storageController) async {
    return await storageController.get(path);
  }
}
