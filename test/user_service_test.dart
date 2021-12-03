// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/consent.dart';
import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/device_service.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/user_service.dart';

void main() {
  final StorageController storageController =
      GenericController("test", DummyMapper("testdb"));
  final UserService userService = UserService(storageController);

  group("UserService ", () {
    setUp(() async {
      // userService.storeUserInfo(User(deviceOwner: Device(deviceId: "2")));
    });

    test("Get userId", () async {
      String user = await userService.getUserId;
      expect(user, TypeMatcher<String>());
    });

    test("get UserInfo when not stored", () async {
      //User user = await userService.getUserInfo;
      expect(() async => await userService.getUserInfo,
          throwsA(TypeMatcher<StorageException>()),
          reason: "failed to store userInfo first");
    });

    test("get UserInf when stored", () async {
      //store userInfo
      await userService.storeUserInfo(User(
          deviceOwner: Device(deviceId: "2"),
          termsAndConditions: TermsAndConditions(),
          consent: Consent()));
      print("${await userService.getUserInfo}");
      expect(() async => await userService.getUserInfo, isNotNull);
    });

    test("test storeTermsAndConditions when false", () async {
      UserService userService = UserService(storageController);
      DeviceService deviceService = DeviceService(storageController);
      //get deviceId
      String dId = await deviceService.getDeviceId;
      //store deviceInfo
      await deviceService.storeDeviceInfo(Device(deviceId: dId));
      //get deviceInfo
      Device deviceInfo = await deviceService.getDeviceInfo;
      //get userId
      String uId = await userService.getUserId;
      //store userInfo
      await userService.storeUserInfo(User(
          termsAndConditions: TermsAndConditions(),
          consent: Consent(),
          deviceOwner: deviceInfo));
      //get userInfo
      User userInfo = await userService.getUserInfo;
      //store user terms and conditions

      bool result = await userService.storeTermsAndConditions(
          termsAndConditions: userInfo.termsAndConditions,
          userInfo: userInfo,
          deviceInfo: userInfo.deviceOwner);
      expect(result, isFalse,
          reason: "termsAndConditions were set to false by default");
    });

    test("test storeTermsAndConditions when true", () async {
      UserService userService = UserService(storageController);
      DeviceService deviceService = DeviceService(storageController);

      //store deviceInfo
      await deviceService.storeDeviceInfo(Device());
      //get deviceInfo
      Device deviceInfo = await deviceService.getDeviceInfo;

      //store userInfo
      await userService.storeUserInfo(User(
          termsAndConditions: TermsAndConditions(
              agreedPrivacy: true, signedConsent: true, ageCompliant: true),
          consent: Consent(),
          deviceOwner: deviceInfo));
      //get userInfo
      User userInfo = await userService.getUserInfo;
      //store user terms and conditions

      bool result = await userService.storeTermsAndConditions(
          termsAndConditions: userInfo.termsAndConditions,
          userInfo: userInfo,
          deviceInfo: userInfo.deviceOwner);
      expect(result, isTrue, reason: "termsAndConditions were set to true ");
    });
  });
}
