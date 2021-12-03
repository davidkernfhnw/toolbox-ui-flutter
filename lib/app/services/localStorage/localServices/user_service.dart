import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';

import '../abstract/local_user.dart';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_localstorage/src/visibility.dart' as vis;

class UserService extends LocalUser {
  UserService(this.storageController);

  StorageController storageController;
  late Node _node;
  late NodeValue _nodeValue;

  // ----------- getters ------------------
  @override
  Future<String> get getUserId async {
    try {
      _node = await getNode(":Local", storageController);
      _nodeValue = (await _node.getValue("currentUser"))!;
      return _nodeValue.value;
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  @override
  Future<User> get getUserInfo async {
    try {
      _node = await getNode(":Local", storageController);
      _nodeValue = (await _node.getValue("userInfo"))!;
      String userInfo = _nodeValue.value;
      User user = User.convertToUser(userInfo);
      return user;
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  // ----------- setters ------------------

  //store user related information
  @override
  Future<void> storeUserInfo(User user) async {
    try {
      _node = await getNode(":Local", storageController);
      String currentUserId = await getUserId;
      user.userId = currentUserId;
      String userInfo = User.convertToJson(user);
      _nodeValue = NodeValueImpl("userInfo", userInfo);
      await _node.addOrUpdateValue(_nodeValue);
      await storageController.update(_node);
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  set setVisibility(vis.Visibility visibility) {}

  @override
  Future<bool> storeTermsAndConditions(
      {required TermsAndConditions termsAndConditions,
      required User userInfo,
      required Device deviceInfo}) async {
    if (termsAndConditions.agreedPrivacy == true &&
        termsAndConditions.signedConsent == true &&
        termsAndConditions.ageCompliant == true) {
      // ///assign termsAndConditions to userInfo
      // userInfo.termsAndConditions = termsAndConditions;
      // ///assign device to userInfo
      // userInfo.deviceOwner = deviceInfo;
      // //store userInfo
      await storeUserInfo(userInfo);
      return true;
    } else {
      return false;
    }
  }
}
