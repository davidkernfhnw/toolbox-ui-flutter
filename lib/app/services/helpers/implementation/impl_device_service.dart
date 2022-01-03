import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

import '../abstract/local_device.dart';

const String _PATH = ":Local";
const String _DEVICE_KEY = "deviceInfo";

abstract class DeviceService extends LocalDevice {
  DeviceService(this.storageController);

  StorageController storageController;
  late NodeValue _nodeValue;

  // ----------- getters ------------------
  @override
  Future<String> get getDeviceId async {
    try {
      _nodeValue =
          (await storageController.getValue(":Local", "currentDevice"))!;
      return _nodeValue.value;
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  @override
  Future<Device> get getDeviceInfo async {
    try {
      _nodeValue = (await storageController.getValue(":Local", "deviceInfo"))!;
      String userInfo = _nodeValue.value;
      Device device = Device.convertToDevice(userInfo);
      return device;
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }

  // ----------- setters ------------------

  //store device related information

  @override
  //stores deviceId into Device object
  Future<bool> storeDeviceInfo(Device device) async {
    try {
      //get deviceId
      String currentDeviceId = await getDeviceId;
      //assign deviceId
      device.deviceId = currentDeviceId;
      String deviceInfo = Device.convertToJson(device);

      bool success = await storageController.addOrUpdateValue(
          _PATH, NodeValueImpl(_DEVICE_KEY, deviceInfo));

      if (success) {
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }
}
