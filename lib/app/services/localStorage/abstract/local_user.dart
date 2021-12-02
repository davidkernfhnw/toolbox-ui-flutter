import 'dart:async';

//import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';

abstract class LocalUser {
  Future<String> get getUserid;

  void set setUserInfo(User user);

  Future<User> get getUserInfo;

  //void storeGeigerScoreAggregate({ Locale? locale,required GeigerScoreThreats geigerScoreThreats });

}
