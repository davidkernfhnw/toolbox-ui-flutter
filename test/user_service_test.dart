// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/consent.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';

void main() {
  final StorageController storageController =
      GenericController("test", DummyMapper("testdb"));
  final GeigerUserService userService = GeigerUserService(storageController);

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

    test("Update userInfo test", () async {
      bool result = await userService.updateUserInfo(
          User(termsAndConditions: TermsAndConditions(), consent: Consent()));
      expect(result, isTrue);
    });
  });
}
