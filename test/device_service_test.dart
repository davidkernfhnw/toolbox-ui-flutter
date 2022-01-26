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
      Device? device = await deviceService.getDeviceInfo;

      expect(() async => device, isNotNull,
          reason: "failed to store deviceInfo first");
    });

    test("Store deviceInfo test", () async {
      bool result = await deviceService.storeDeviceInfo(Device());
      expect(result, isTrue);
    });

    test("get DeviceInfo when stored", () async {
      //store userInfo
      await deviceService.storeDeviceInfo(Device());
      print("${await deviceService.getDeviceInfo}");
      expect(() async => await deviceService.getDeviceInfo, isNotNull);
    });
  });
}
