import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_toolbox/app/services/localStorage/abstract/local_device.dart';

class DeviceService extends LocalDevice {
  @override
  // TODO: implement getDeviceId
  Future<String> get getDeviceId => throw UnimplementedError();

  @override
  set setDeviceInfo(Device device) {
    // TODO: implement setDeviceInfo
  }

  @override
  // TODO: implement getDeviceInfo
  Future<Device> get getDeviceInfo => throw UnimplementedError();
}
