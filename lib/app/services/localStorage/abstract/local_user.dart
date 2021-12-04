import 'dart:async';

//import 'package:flutter/material.dart';

import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';

abstract class LocalUser {
  Future<String> get getUserId;

  Future<void> storeUserInfo(User user);

  Future<User?> get getUserInfo;

  Future<bool> storeTermsAndConditions(
      {required TermsAndConditions termsAndConditions});
  //void storeGeigerScoreAggregate({ Locale? locale,required GeigerScoreThreats geigerScoreThreats });

}
