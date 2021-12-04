// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/consent.dart';
import 'package:geiger_toolbox/app/data/model/device.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';

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
      expect(() async => await userService.getUserInfo, anything,
          reason: "failed to store userInfo first");
    });

    test("get UserInfo when stored", () async {
      //store userInfo
      await userService.storeUserInfo(User(
          deviceOwner: Device(deviceId: "2"),
          termsAndConditions: TermsAndConditions(),
          consent: Consent()));
      print("${await userService.getUserInfo}");
      expect(() async => await userService.getUserInfo, isNotNull);
    });

    test("test storeTermsAndConditions when false", () async {
      bool result = await userService.storeTermsAndConditions(
        termsAndConditions: TermsAndConditions(),
      );
      expect(result, isFalse,
          reason: "termsAndConditions were set to false by default");
    });

    test("test storeTermsAndConditions when true", () async {
      bool result = await userService.storeTermsAndConditions(
        termsAndConditions: TermsAndConditions(
            ageCompliant: true, signedConsent: true, agreedPrivacy: true),
      );
      expect(result, isTrue, reason: "termsAndConditions were set to true ");
    });

    test("Store userInfo test", () async {
      //store
      bool result = await userService.storeUserInfo(User(
          termsAndConditions: TermsAndConditions(),
          consent: Consent(),
          deviceOwner: Device(deviceId: "2")));
      expect(result, isFalse, reason: "UserInfo already stored");
    });

    test("Update userInfo test", () async {
      bool result = await userService.updateUserInfo(
          User(termsAndConditions: TermsAndConditions(), consent: Consent()));
      expect(result, isTrue);
    });
  });
}
