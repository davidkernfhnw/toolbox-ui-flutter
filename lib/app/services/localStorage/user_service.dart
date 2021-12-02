import 'package:geiger_toolbox/app/data/model/user.dart';

import 'abstract/local_user.dart';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_localstorage/src/visibility.dart' as vis;

class UserService implements LocalUser {
  StorageController storageController;

  UserService(this.storageController);

  late Node _node;
  late NodeValue _nodeValue;

  // ----------- getters ------------------
  @override
  // TODO: implement getUserid
  Future<String> get getUserId async {
    try {
      _node = await _getNode(":Local");
      _nodeValue = (await _node.getValue("currentUser"))!;
      return _nodeValue.value;
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  @override
  // TODO: implement getUserInfo
  Future<User> get getUserInfo async {
    try {
      _node = await _getNode(":Local");
      _nodeValue = (await _node.getValue("userInfo"))!;
      String userInfo = _nodeValue.value;
      User user = User.convertToUser(userInfo);
      return user;
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  // ----------- setters ------------------

  //store user relation information
  @override
  void storeUserInfo(User user) async {
    try {
      _node = await _getNode(":Local");
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

// ----- Helpers
  Future<Node> _getNode(String path) async {
    return await storageController.get(path);
  }

  set setVisibility(vis.Visibility visibility) {}
}
