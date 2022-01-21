import 'dart:async';

//import 'package:flutter/material.dart';

import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';

abstract class LocalUserService {
  /// @return userId as a Future<String>
  /// from the Local node
  Future<String> get getUserId;

  /// @param User object
  /// @return Future<bool>
  /// store in the Local node
  Future<bool> storeUserInfo(User user);

  /// @return Future<User?>
  /// retrieve user from Local node
  Future<User?> get getUserInfo;

  /// @return Future<bool>
  Future<bool> storeTermsAndConditions(
      {required TermsAndConditions termsAndConditions});

  /// @return Future<bool>
  Future<bool> updateUserInfo(User user);

  ///set newUser to true
  Future<void> setNewUserStatus({bool value});

  ///update newUser to false
  Future<void> updateNewUserStatus({bool value});

  /// @return Future<bool>
  Future<bool> checkNewUserStatus();
}
