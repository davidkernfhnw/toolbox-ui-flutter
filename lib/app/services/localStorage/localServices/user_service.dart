import 'package:geiger_toolbox/app/data/model/consent.dart';
import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';

import '../abstract/local_user.dart';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_localstorage/src/visibility.dart' as vis;

import 'device_service.dart';

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
  Future<User?> get getUserInfo async {
    _node = await getNode(":Local", storageController);
    if (await _node.getValue("userInfo") != null) {
      _nodeValue = (await _node.getValue("userInfo"))!;
      String userInfo = _nodeValue.value;
      User user = User.convertToUser(userInfo);
      return user;
    } else {
      return null;
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
      {required TermsAndConditions termsAndConditions}) async {
    if (termsAndConditions.agreedPrivacy == true &&
        termsAndConditions.signedConsent == true &&
        termsAndConditions.ageCompliant == true) {
      //instance of DeviceService
      DeviceService deviceService = DeviceService(storageController);

      //store deviceInfo
      await deviceService.storeDeviceInfo(Device());
      //get deviceInfo
      Device deviceInfo = await deviceService.getDeviceInfo;

      //instance of user
      User user = User(
          termsAndConditions: termsAndConditions,
          consent: Consent(),
          deviceOwner: deviceInfo);

      //store userInfo
      await storeUserInfo(user);
      return true;
    } else {
      return false;
    }
  }
}
