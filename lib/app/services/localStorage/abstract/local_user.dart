import 'dart:async';

//import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';

abstract class LocalUser {
  Future<String> get getUserId;

  void storeUserInfo(User user);

  Future<User> get getUserInfo;

  //void storeGeigerScoreAggregate({ Locale? locale,required GeigerScoreThreats geigerScoreThreats });

}
