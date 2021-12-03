// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/device_service.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

void main() {
  final StorageController storageController =
      GenericController("test", DummyMapper("testdb"));
  final DeviceService deviceService = DeviceService(storageController);

  group("DeviceService ", () {
    setUp(() async {
      // userService.storeUserInfo(User(deviceOwner: Device(deviceId: "2")));
    });

    test("Get deviceId", () async {
      String device = await deviceService.getDeviceId;
      expect(device, TypeMatcher<String>());
    });

    test("get deviceInfo when not stored", () async {
      expect(() async => await deviceService.getDeviceInfo,
          throwsA(TypeMatcher<StorageException>()),
          reason: "failed to store deviceInfo first");
    });

    test("get DeviceInf when stored", () async {
      //store userInfo
      await deviceService.storeDeviceInfo(Device());
      print("${await deviceService.getDeviceInfo}");
      expect(() async => await deviceService.getDeviceInfo, isNotNull);
    });
  });
}
