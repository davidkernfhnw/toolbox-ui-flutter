import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart' as local;
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/dummy_storage_controller.dart';
import 'package:geiger_toolbox/app/services/ui_storage_controller.dart';

import 'package:get/get.dart';

class TermsAndConditionsController extends GetxController {
  GeigerDummy? _geigerDummy = GeigerDummy();
  late final local.StorageController storageController;
  //UiStorageController _uiStorageInstance = UiStorageController.instance;
  DummyStorageController _dummyStorageInstance =
      DummyStorageController.instance;
  static TermsAndConditionsController to = Get.find();

  var ageCompliant = false.obs;
  var signedConsent = false.obs;
  var agreedPrivacy = false.obs;

  var error = false.obs;

  //DummystorageController
  _init() async {
    storageController = await _dummyStorageInstance.getDummyController;
  }

  Future<void> agreed() async {
    if (ageCompliant.value == true &&
        signedConsent.value == true &&
        agreedPrivacy.value == true) {
      error.value = false;
      //_localStorage.storeNewUser(true);
      await _geigerDummy!.initialGeigerDummyData(
          TermsAndConditions(
              ageCompliant: true, signedConsent: true, agreedPrivacy: true),
          storageController);
      Get.offNamed(Routes.HOME_VIEW);
    } else {
      error.value = true;
    }
  }

  Future<void> previouslyAgreed() async {
    try {
      UserNode _userNode = UserNode(storageController);
      TermsAndConditions userTerms = await _userNode.getUserInfo
          .then((User value) => value.termsAndConditions);

      if (await userTerms.ageCompliant == true &&
          await userTerms.signedConsent == true &&
          await userTerms.agreedPrivacy == true) {
        //user to false;

        //Future.delayed(Duration(seconds: 2));
        Get.offNamed(Routes.HOME_VIEW);
      }
    } catch (e) {
      log("Error: User not created");
      log("Error from TermsAndConditionController $e\n");
    }
  }

  @override
  void onInit() async {
    super.onInit();

    //init DummystorageController
    await _init();
    //check if terms and condition were previously agreed
    await previouslyAgreed();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    //storageController.close();
    super.dispose();
  }
}
