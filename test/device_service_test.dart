// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';

void main() {
  final StorageController storageController =
      GenericController("test", DummyMapper("testdb"));
  final GeigerUserService deviceService = GeigerUserService(storageController);

  group("DeviceService ", () {
    test("Get deviceId", () async {
      String device = await deviceService.getDeviceId;
      expect(device, TypeMatcher<String>());
    });

    test("get deviceInfo when not stored", () async {
      expect(() async => await deviceService.getDeviceInfo,
          throwsA(TypeMatcher<StorageException>()),
          reason: "failed to store deviceInfo first");
    });

    test("get DeviceInfo when stored", () async {
      //store userInfo
      await deviceService.storeDeviceInfo(Device());
      print("${await deviceService.getDeviceInfo}");
      expect(() async => await deviceService.getDeviceInfo, isNotNull);
    });

    test("Store deviceInfo test", () async {
      bool result = await deviceService.storeDeviceInfo(Device());
      expect(result, isFalse,
          reason: "DeviceInfo already stored and can't be updated");
    });
  });
}
