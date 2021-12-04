import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_toolbox/app/services/localStorage/abstract/local_device.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

class DeviceService extends LocalDevice {
  DeviceService(this.storageController);

  StorageController storageController;
  late Node _node;
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
  Future<void> storeDeviceInfo(Device device) async {
    try {
      _node = await getNode(":Local", storageController);
      String currentDeviceId = await getDeviceId;
      device.deviceId = currentDeviceId;
      String deviceInfo = Device.convertToJson(device);
      _nodeValue = NodeValueImpl("deviceInfo", deviceInfo);
      await _node.addOrUpdateValue(_nodeValue);
      await storageController.update(_node);
    } catch (e, s) {
      throw StorageException("Failed to retrieve the Local node\n $e", s);
    }
  }
}
