import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/local_storage.dart';
import 'package:get/get.dart';

import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

class TermsAndConditionsController extends GetxController {
  StorageController? _storageController;
  GeigerApi? _geigerApi;

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
          ageCompliant: ageCompliant.value,
          signedConsent: signedConsent.value,
          agreedPrivacy: agreedPrivacy.value));
      Get.toNamed(Routes.HOME_VIEW);
    } else {
      error.value = true;
    }
  }

  void _agreedPreviously() {
    try {
      UserNode _userNode = UserNode(_storageController!);
      TermsAndConditions userTerms = _userNode.getUserInfo!.termsAndConditions;

      if (userTerms.ageCompliant == true &&
          userTerms.signedConsent == true &&
          userTerms.agreedPrivacy == true) {
        Get.toNamed(Routes.HOME_VIEW);
      }
    } catch (e) {
      Get.offNamed(Routes.TERMS_AND_CONDITIONS);
    }
  }

  @override
  void onInit() async {
    super.onInit();

    //storageController and geigerApi
    await _init();
    //check if terms and condition were previously agreed
    _agreedPreviously();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
