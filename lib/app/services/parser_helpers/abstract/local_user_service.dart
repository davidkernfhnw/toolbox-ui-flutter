import 'dart:async';

//import 'package:flutter/material.dart';

import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';

abstract class LocalUserService {
  /// @return userId as a Future<String>
  /// from the Local node
  Future<String> get getUserId;

  /// @return Future<User?>
  /// retrieve user from Local node
  Future<User?> get getUserInfo;

  /// @return Future<bool>
  Future<bool> storeTermsAndConditions(
      {required TermsAndConditions termsAndConditions});

  ///@param optional
  ///@return Future<bool>
  Future<bool> storeUserConsent(
      {bool dataAccess: true, bool dataProcess: true});

  Future<bool> updateUserConsentDataAccess({required bool dataAccess});

  Future<bool> updateUserConsentDataProcess({required bool dataProcess});

  Future<bool?> get getUserConsentDataAccess;

  Future<bool?> get getUserConsentDataProcess;

  /// @return Future<bool>
  Future<bool> updateUserInfo(User user);

  ///set newUser to true
  Future<void> setButtonNotPressed({bool value});

  ///update newUser to false
  Future<void> updateButtonPressed({bool value});

  /// @return Future<bool>
  Future<bool> isButtonPressed();
}
