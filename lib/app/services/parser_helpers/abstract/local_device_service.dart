import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/device.dart';

const String _LOCAL_PATH = ":Local";
const String _UI_PATH = ":Local:ui";
const String _DEVICE_KEY = "deviceInfo";
const String _NODE_OWNER = "geiger-toolbox";

abstract class LocalDeviceService {
  LocalDeviceService(this.storageController);

  StorageController storageController;
  late NodeValue _nodeValue;

  // ----------- getters ------------------
  /// @return deviceId as a Future<String>
  /// from the Local node

  Future<String> get getDeviceId async {
    try {
      _nodeValue =
          (await storageController.getValue(_LOCAL_PATH, "currentDevice"))!;
      return _nodeValue.value;
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  /// @param Device object
  /// @return Future<bool>
  /// store in the Local node

  Future<Device?> get getDeviceInfo async {
    try {
      _nodeValue = (await storageController.getValue(_UI_PATH, _DEVICE_KEY))!;
      String userInfo = _nodeValue.value;
      Device device = Device.convertToDevice(userInfo);
      return device;
    } catch (e) {
      return null;
    }
  }

  // ----------- setters ------------------

  //store device related information

  /// @return Future<Device>
  /// retrieve user from Local node

  //stores deviceId into Device object
  Future<bool> storeDeviceInfo(Device device) async {
    Node uiNode;
    try {
      uiNode = await storageController.get(_UI_PATH);
    } catch (e) {
      uiNode = NodeImpl(_UI_PATH, _NODE_OWNER);
      await storageController.addOrUpdate(uiNode);
    }

    try {
      //get deviceId
      String currentDeviceId = await getDeviceId;
      //assign deviceId
      device.deviceId = currentDeviceId;
      print("${await getDeviceName}");
      device.name = await getDeviceName;
      device.type = await getDeviceType;
      String deviceInfo = Device.convertToJson(device);

      bool success = await storageController.addOrUpdateValue(
          _UI_PATH, NodeValueImpl(_DEVICE_KEY, deviceInfo));

      if (success) {
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  /// @return Future<List<String>>
  Future<List<String>> getListPairedDevices() async {
    Node node = await storageController.get(":Devices");
    List<String> ids =
        await node.getChildNodesCsv().then((value) => value.split(','));
    log("Dump devices id ==> ${await storageController.dump(":Devices")}");
    return ids;
  }

  //get name of the user device
  Future<String> get getDeviceName async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model!;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.utsname.machine!;
    } else if (Platform.isMacOS) {
      //Todo can't get MacOs device name
      //MacOsDeviceInfo macOsDeviceInfo = await deviceInfo.macOsInfo;
      //String macOs = macOsDeviceInfo.model;
      String macOs = "MacOs";
      return macOs;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo w = await deviceInfo.windowsInfo;
      String window = w.computerName;
      return window;
    } else {
      WebBrowserInfo web = await deviceInfo.webBrowserInfo;
      String browser = web.browserName.name;
      return browser;
    }
  }

  //get devicetype
  String get getDeviceType {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return "IPhone";
    } else if (Platform.isMacOS) {
      return "Mac Book";
    } else if (Platform.isWindows) {
      return "Windows Desktop";
    } else {
      return "Web Browser";
    }
  }

// ----- Helpers
  Future<Node> getNode(String path, StorageController storageController) async {
    return await storageController.get(path);
  }
}
