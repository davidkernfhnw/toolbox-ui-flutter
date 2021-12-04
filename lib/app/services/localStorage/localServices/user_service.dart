import 'dart:developer';

import 'package:geiger_toolbox/app/data/model/consent.dart';
import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';

import '../abstract/local_user.dart';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_localstorage/src/visibility.dart' as vis;

import 'device_service.dart';

const String _PATH = ":Local";
const String _USER_KEY = "userInfo";

class UserService extends DeviceService implements LocalUser {
  UserService(this.storageController) : super(storageController);

  StorageController storageController;
  late NodeValue _nodeValue;
  late Node _node;
  // ----------- getters ------------------
  @override
  Future<String> get getUserId async {
    try {
      _nodeValue = (await storageController.getValue(_PATH, "currentUser"))!;
      return _nodeValue.value;
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  @override
  Future<User?> get getUserInfo async {
    _nodeValue = (await storageController.getValue(_PATH, _USER_KEY))!;
    String userInfo = _nodeValue.value;
    User user = User.convertToUser(userInfo);
    return user;
  }

  //store user related information
  @override
  Future<bool> storeUserInfo(User user) async {
    try {
      //get userId
      String currentUserId = await getUserId;
      //assign userid
      user.userId = currentUserId;
      //store deviceInfo
      await storeDeviceInfo(Device());
      //get deviceInfo
      Device deviceInfo = await getDeviceInfo;
      //assign deviceInf
      user.deviceOwner = deviceInfo;

      String userInfo = User.convertToJson(user);

      bool success = await storageController.addOrUpdateValue(
          _PATH, NodeValueImpl(_USER_KEY, userInfo));
      if (success) {
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  set setVisibility(vis.Visibility visibility) {}

  @override
  Future<bool> storeTermsAndConditions(
      {required TermsAndConditions termsAndConditions}) async {
    if (termsAndConditions.agreedPrivacy == true &&
        termsAndConditions.signedConsent == true &&
        termsAndConditions.ageCompliant == true) {
      //instance of user
      User user =
          User(termsAndConditions: termsAndConditions, consent: Consent());

      //store userInfo
      await storeUserInfo(user);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateUserInfo(User user) async {
    try {
      _node = await getNode(":Local", storageController);
      // convert User to String
      String userInfo = User.convertToJson(user);
      //update userInfo
      _nodeValue = NodeValueImpl("userInfo", userInfo);
      await _node.addOrUpdateValue(_nodeValue);
      await storageController.update(_node);

      //using this will not be able to update the node
      //only used when update is not required
      // bool success = await storageController.addOrUpdateValue(
      //     _PATH, NodeValueImpl(_USER_KEY, userInfo));
      // if (success) {
      //   return true;
      // } else {
      //   return false;
      // }
      return true;
    } catch (e, s) {
      log("failed due to unexpected exception\n $e \n $s");
      return false;
    }
  }
}
