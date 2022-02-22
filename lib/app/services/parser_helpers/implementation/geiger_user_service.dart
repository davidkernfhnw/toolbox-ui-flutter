import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_localstorage/src/visibility.dart' as vis;
import 'package:geiger_toolbox/app/model/consent.dart';
import 'package:geiger_toolbox/app/model/device.dart';
import 'package:geiger_toolbox/app/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/model/user.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/bool_parsing_extension.dart';

import '../abstract/local_device_abstract.dart';
import '../abstract/local_user_abstract.dart';

const String _LOCAL_PATH = ":Local";
const String _UI_PATH = ":Local:ui";
const String _USER_KEY = "userInfo";
const String _NODE_OWNER = "geiger-toolbox";
const String _BUTTON_KEY = "buttonPressed";
const String _USER_CONSENT_PATH = ":Local:UserConsent";
const String _DATA_ACCESS_KEY = "dataAccess";
const String _DO_NOT_SHARE_KEY = "doNotShare";
const String _REPLICATE_KEY = "replicate";

class GeigerUserService extends LocalDeviceAbstract
    implements LocalUserAbstract {
  GeigerUserService(this.storageController) : super(storageController);

  StorageController storageController;
  late NodeValue _nodeValue;
  late Node _node;
  // ----------- getters ------------------
  @override
  Future<String> get getUserId async {
    try {
      _nodeValue =
          (await storageController.getValue(_LOCAL_PATH, "currentUser"))!;
      return _nodeValue.value;
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  @override
  Future<User?> get getUserInfo async {
    try {
      _nodeValue = (await storageController.getValue(_UI_PATH, _USER_KEY))!;
      String userInfo = _nodeValue.value;
      User user = User.convertToUser(userInfo);
      return user;
    } catch (e) {
      return null;
    }
  }

  //store user related information
  Future<bool> _storeUserInfo(User user) async {
    Node uiNode;
    try {
      uiNode = await storageController.get(_UI_PATH);
    } catch (e) {
      uiNode = NodeImpl(_UI_PATH, _NODE_OWNER);
      await storageController.addOrUpdate(uiNode);
    }

    try {
      //get userId
      String currentUserId = await getUserId;
      //assign userid
      user.userId = currentUserId;
      //store deviceInfo
      await storeDeviceInfo(Device());
      //get deviceInfo
      Device? deviceInfo = await getDeviceInfo;

      //assign deviceInf
      user.deviceOwner = deviceInfo;

      String userInfo = User.convertToJson(user);

      bool success = await storageController.addOrUpdateValue(
          _UI_PATH, NodeValueImpl(_USER_KEY, userInfo));
      if (success) {
        log("USERINFO => ${await storageController.dump(_UI_PATH)}");
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
      await _storeUserInfo(user);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateUserInfo(User user) async {
    try {
      _node = await getNode(_UI_PATH, storageController);
      // convert User to String
      String userInfo = User.convertToJson(user);
      //update userInfo
      _nodeValue = NodeValueImpl(_USER_KEY, userInfo);
      //does not update if nodeValue is already existing
      //await _node.addOrUpdateValue(_nodeValue);
      await _node.updateValue(_nodeValue);
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

  @override
  Future<void> setButtonNotPressed({bool value: true}) async {
    try {
      Node node = await storageController.get(_UI_PATH);
      await node.addOrUpdateValue(NodeValueImpl(_BUTTON_KEY, value.toString()));
      await storageController.addOrUpdate(node);
    } catch (e, s) {
      StorageException("Storage Error: $e", s);
    }
  }

  @override
  Future<void> updateButtonPressed({bool value: false}) async {
    try {
      Node node = await storageController.get(_UI_PATH);
      //Note: If nodeValue is already exist used updateValue() to update it
      await node.updateValue(NodeValueImpl(_BUTTON_KEY, value.toString()));

      await storageController.update(node);
    } catch (e, s) {
      StorageException("Storage Error: $e", s);
    }
  }

  @override
  Future<bool> isButtonPressed() async {
    try {
      NodeValue? nodeValue =
          await storageController.getValue(_UI_PATH, _BUTTON_KEY);
      String newUser = nodeValue!.value;
      bool isNewUser = newUser.parseBool();

      if (isNewUser == true) {
        log("ScanButton has never be pressed before : $newUser");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Error from storageControllerUi");
      return false;
    }
  }

  @override
  Future<bool> storeUserConsent(
      {bool dataAccess = false, bool dataProcess = false}) async {
    Node uiNode;
    try {
      uiNode = await storageController.get(_USER_CONSENT_PATH);
    } catch (e) {
      uiNode = NodeImpl(_USER_CONSENT_PATH, _NODE_OWNER);
      await storageController.addOrUpdate(uiNode);
    }
    try {
      bool isDaStored = await storageController.addOrUpdateValue(
          _USER_CONSENT_PATH,
          NodeValueImpl(_DATA_ACCESS_KEY, dataAccess.toString()));
      log("Consent Data ${await storageController.dump(_USER_CONSENT_PATH)}");
      if (isDaStored) {
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      throw StorageException(
          "Failed to retrieve the $_USER_CONSENT_PATH node\n $e", s);
    }
  }

  @override
  Future<bool> updateUserConsentDataAccess({required bool dataAccess}) async {
    Node _node;
    try {
      _node = await getNode(_USER_CONSENT_PATH, storageController);

      NodeValue dataAccessValue =
          NodeValueImpl(_DATA_ACCESS_KEY, dataAccess.toString());

      await _node.updateValue(dataAccessValue);
      await storageController.update(_node);
      log("Update Access Data ${await storageController.dump(_USER_CONSENT_PATH)}");
      return true;
    } catch (e, s) {
      log("failed To update UserConsent DataAccess \n $e \n $s");
      return false;
    }
  }

  @override
  Future<bool?> get getUserConsentDataAccess async {
    try {
      NodeValue dataAccessValue = (await storageController.getValue(
          _USER_CONSENT_PATH, _DATA_ACCESS_KEY))!;
      bool dataAccess = dataAccessValue.value.parseBool();
      log("Data Access ==> ${await storageController.dump(_USER_CONSENT_PATH)}");
      return dataAccess;
    } catch (e) {
      log("Failed to get data from $_USER_CONSENT_PATH");
      return null;
    }
  }

  @override
  Future<bool?> checkUserConsent() async {
    try {
      NodeValue dataAccessValue = (await storageController.getValue(
          _USER_CONSENT_PATH, _DATA_ACCESS_KEY))!;
      bool dataAccess = dataAccessValue.value.parseBool();
      log("Check UserConsent ==> ${await storageController.dump(_USER_CONSENT_PATH)}");
      if (dataAccess == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Failed to get data from $_USER_CONSENT_PATH");
      return null;
    }
  }

  @override
  Future<bool> storeDoNotShareConsent({int doNotShare = 0}) async {
    try {
      bool isDoNotShare = await storageController.addOrUpdateValue(
          _USER_CONSENT_PATH,
          NodeValueImpl(_DO_NOT_SHARE_KEY, doNotShare.toString()));

      log("Don't share Data ${await storageController.dump(_USER_CONSENT_PATH)}");
      if (isDoNotShare) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw StorageException(
          "Failed to retrieve the $_USER_CONSENT_PATH node\n $e");
    }
  }

  @override
  Future<bool> storeReplicateConsent({required int replicateData}) async {
    try {
      bool rep = await storageController.addOrUpdateValue(_USER_CONSENT_PATH,
          NodeValueImpl(_REPLICATE_KEY, replicateData.toString()));

      log("Replicate Data ${await storageController.dump(_USER_CONSENT_PATH)}");
      if (rep) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw StorageException(
          "Failed to retrieve the $_USER_CONSENT_PATH node\n $e");
    }
  }

  @override
  Future<bool?> checkDoNotShareConsent() async {
    try {
      NodeValue doNotShareValue = (await storageController.getValue(
          _USER_CONSENT_PATH, _DO_NOT_SHARE_KEY))!;
      int share = int.parse(doNotShareValue.value);
      if (share == 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Failed to get data from $_USER_CONSENT_PATH");
      return null;
    }
  }

  @override
  Future<bool?> checkReplicationConsent() async {
    try {
      NodeValue replicateValue = (await storageController.getValue(
          _USER_CONSENT_PATH, _REPLICATE_KEY))!;
      int rep = int.parse(replicateValue.value);
      if (rep == 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Failed to get data from $_USER_CONSENT_PATH");
      return null;
    }
  }

  @override
  Future<bool> updateDoNotShareConsent({required int doNotShareData}) async {
    Node _node;
    try {
      _node = await getNode(_USER_CONSENT_PATH, storageController);

      NodeValue dataAccessValue =
          NodeValueImpl(_DO_NOT_SHARE_KEY, doNotShareData.toString());

      await _node.updateValue(dataAccessValue);
      await storageController.update(_node);
      log("DOnt share $_node");
      return true;
    } catch (e) {
      log("failed To update  \n $e ");
      return false;
    }
  }

  @override
  Future<bool> updateReplicateConsent({required int replicateData}) async {
    Node _node;
    try {
      _node = await getNode(_USER_CONSENT_PATH, storageController);

      NodeValue dataAccessValue =
          NodeValueImpl(_REPLICATE_KEY, replicateData.toString());

      await _node.updateValue(dataAccessValue);

      await storageController.update(_node);
      log("replicate update =>$_node");
      return true;
    } catch (e) {
      log("failed To update \n $e");
      return false;
    }
  }

  @override
  // TODO: implement getDataSharingConsent
  Future<int?> get getDoNotShareConsent async {
    try {
      NodeValue dataAccessValue = (await storageController.getValue(
          _USER_CONSENT_PATH, _DO_NOT_SHARE_KEY))!;
      int data = int.parse(dataAccessValue.value);
      log("DO not share value ==> $data");
      return data;
    } catch (e) {
      log("Failed to get data from $_USER_CONSENT_PATH");
      return null;
    }
  }

  @override
  // TODO: implement getReplicateConsent
  Future<int?> get getReplicateConsent async {
    try {
      NodeValue dataAccessValue = (await storageController.getValue(
          _USER_CONSENT_PATH, _REPLICATE_KEY))!;
      int data = int.parse(dataAccessValue.value);
      log("Replicate consent Value: $data");
      return data;
    } catch (e) {
      log("Failed to get data from $_USER_CONSENT_PATH");
      return null;
    }
  }

  // Future<bool> setImproveButton({bool value: true}) async {
  //   try {
  //     Node node=
  //     await storageController.get(_UI_PATH);
  //
  //     await node.addOrUpdateValue(NodeValueImpl(_IMPROVE_KEY, value.toString()));
  //     await storageController.addOrUpdate(node);
  //     log("setImproveButton: $node");
  //
  //     return true;
  //   } catch (e) {
  //     log('Failed to get node :Local:ui ');
  //     log(e.toString());
  //     return false;
  //   }
  // }
  //
  // Future<bool> isImproveButtonPressed() async {
  //   try {
  //     NodeValue? nodeValue =
  //     await storageController.getValue(_UI_PATH, _BUTTON_KEY);
  //     String newUser = nodeValue!.value;
  //     bool isNewUser = newUser.parseBool();
  //
  //     if (isNewUser == true) {
  //       log("ScanButton has never be pressed before : $newUser");
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     log("Error from storageControllerUi");
  //     return false;
  //   }
  // }
}
