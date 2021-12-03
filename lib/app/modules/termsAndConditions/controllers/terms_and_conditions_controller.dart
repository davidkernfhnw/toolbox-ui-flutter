import 'dart:developer';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/user_service.dart';
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

  // declaring variable for creativeness
  var ageCompliant = false.obs;
  var signedConsent = false.obs;
  var agreedPrivacy = false.obs;
  var errorMsg = false.obs;

  //check if terms and condition values is true in the localstorage
  // and navigate to home view (screen)
  //if false navigate to TermAndCondition view(screen).
  Future<void> checkExistingTerms() async {
    //instance of userService
    UserService userService = UserService(_storageController!);
    //get user Info
    User? userInfo = await userService.getUserInfo;
    if (userInfo != null) {
      // assign user term and condition
      TermsAndConditions userTermsAndConditions = userInfo.termsAndConditions;
      //check if true and return home view (screen)
      if (await userTermsAndConditions.ageCompliant == true &&
          await userTermsAndConditions.signedConsent == true &&
          await userTermsAndConditions.agreedPrivacy == true) {
        //Future.delayed(Duration(seconds: 2));
        Get.offNamed(Routes.HOME_VIEW);
      }
    } else {
      //show default screen(TermsAndConditions view)
      log("UserInfo not found");
    }
  }

  //store accepted termsAndCondition
  //show error message if all terms and condition are not check
  //else navigate to Home view
  Future<void> acceptTerms() async {
    //instance of userService
    UserService userService = UserService(_storageController!);
    if (ageCompliant.value == true &&
        signedConsent.value == true &&
        agreedPrivacy.value == true) {
      //set errorMsg to false
      errorMsg.value = false;
      //store user accepted term and conditions
      bool success = await userService.storeTermsAndConditions(
          termsAndConditions: TermsAndConditions(
              ageCompliant: ageCompliant.value,
              signedConsent: signedConsent.value,
              agreedPrivacy: agreedPrivacy.value));
      if (success) {
        Get.offNamed(Routes.HOME_VIEW);
      } else {
        //set errorMsg to true
        errorMsg.value = true;
        log("Failed to store terms and conditions");
      }
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
