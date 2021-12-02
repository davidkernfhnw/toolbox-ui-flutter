import 'package:geiger_toolbox/app/data/model/user.dart';

import 'abstract/local_user.dart';

class UserService implements LocalUser {
  @override
  // TODO: implement getUserid
  Future<String> get getUserid => throw UnimplementedError();

  @override
  // TODO: implement getUserInfo
  Future<User> get getUserInfo => throw UnimplementedError();

  @override
  set setUserInfo(User user) {
    // TODO: implement setUserInfo
  }
}
