import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/local_storage.dart';
import 'package:get/get.dart';

class TermsAndConditionsController extends GetxController {
  GeigerApi? _geigerApi;
  StorageController? _storageController;

  static TermsAndConditionsController to = Get.find();

  var ageCompliant = false.obs;
  var signedConsent = false.obs;
  var agreedPrivacy = false.obs;

  var error = false.obs;

  //storageController
  _init() async {
    _storageController = await LocalStorage.initLocalStorage();
    _geigerApi = GeigerApi(_storageController!);
  }

  Future<void> agreed() async {
    if (ageCompliant.value == true &&
        signedConsent.value == true &&
        agreedPrivacy.value == true) {
      error.value = false;
      await _geigerApi!.initialGeigerDummyData(TermsAndConditions(
          ageCompliant: true, signedConsent: true, agreedPrivacy: true));
      Get.offNamed(Routes.HOME_VIEW);
    } else {
      error.value = true;
    }
  }

  Future<void> previouslyAgreed() async {
    try {
      UserNode _userNode = UserNode(_storageController!);
      TermsAndConditions userTerms = await _userNode.getUserInfo
          .then((User value) => value.termsAndConditions);

      if (await userTerms.ageCompliant == true &&
          await userTerms.signedConsent == true &&
          await userTerms.agreedPrivacy == true) {
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

    //init storageController and geigerApi
    await _init();
    // //check if terms and condition were previously agreed
    await previouslyAgreed();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    _storageController!.close();
    super.dispose();
  }
}
