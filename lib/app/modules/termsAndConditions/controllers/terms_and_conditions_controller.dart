import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';

import 'package:get/get.dart';

class TermsAndConditionsController extends GetxController {
  //instance of TermsAndConditionController
  static TermsAndConditionsController to = Get.find();

  //get instance of LocalStorageController
  LocalStorageController _localStorage = LocalStorageController.to;

  //declaring storageController
  StorageController? _storageController;

  //initialize _storageController using _localStorage instance
  _initializeStorageController() {
    _storageController = _localStorage.getStorageController;
  }

  dummy.GeigerDummy? _geigerDummy = dummy.GeigerDummy();

  // declaring variable for creativeness
  var ageCompliant = false.obs;
  var signedConsent = false.obs;
  var agreedPrivacy = false.obs;
  var errorMsg = false.obs;

  //check if terms and condition values is true in the localstorage
  // and navigate to home view (screen)
  //if false navigate to TermAndCondition view(screen).
  Future<void> checkExistingTerms() async {
    try {
      dummy.UserNode _userNode = dummy.UserNode(_storageController!);
      dummy.TermsAndConditions userTerms = await _userNode.getUserInfo
          .then((dummy.User value) => value.termsAndConditions);

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

  //store accepted termsAndCondition
  //show error message if all terms and condition are not check
  //else navigate to Home view
  Future<void> acceptTerms() async {
    if (ageCompliant.value == true &&
        signedConsent.value == true &&
        agreedPrivacy.value == true) {
      //set errorMsg to false
      errorMsg.value = false;
      await _geigerDummy!.initialGeigerDummyData(
          _storageController!,
          dummy.TermsAndConditions(
              ageCompliant: ageCompliant.value,
              signedConsent: signedConsent.value,
              agreedPrivacy: agreedPrivacy.value));
      Get.offNamed(Routes.HOME_VIEW);
    } else {
      //set errorMsg to true
      errorMsg.value = true;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    //init storageController
    _initializeStorageController();
    //check if terms and condition were previously agreed
    await checkExistingTerms();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() async {
    super.dispose();
    //close storageController after use
    await _storageController!.close();
  }
}
