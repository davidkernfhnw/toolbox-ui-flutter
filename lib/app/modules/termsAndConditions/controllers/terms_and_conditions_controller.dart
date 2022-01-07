import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/impl_user_service.dart';
import 'package:get/get.dart';

class TermsAndConditionsController extends GetxController {
  //instance of TermsAndConditionController
  static TermsAndConditionsController instance = Get.find();

  //get instance of LocalStorageController
  LocalStorageController _localStorageInstance =
      LocalStorageController.instance;

  //declaring storageController
  late StorageController _storageController;
  late UserService _userService;

  //initialize _storageController using _localStorage instance
  _initializeStorageController() {
    _storageController = _localStorageInstance.getStorageController;
    _userService = UserService(_storageController);
  }

  // declaring variable for creativeness
  var ageCompliant = false.obs;
  var signedConsent = false.obs;
  var agreedPrivacy = false.obs;
  var errorMsg = false.obs;

  //check if terms and condition values is true in the localstorage
  // and navigate to home view (screen)
  //if false navigate to TermAndCondition view(screen).
  Future<bool> isTermsAccepted() async {
    try {
      //get user Info
      User? userInfo = await _userService.getUserInfo;
      if (userInfo != null) {
        // assign user term and condition
        TermsAndConditions userTermsAndConditions = userInfo.termsAndConditions;
        //check if true and return home view (screen)
        if (await userTermsAndConditions.ageCompliant == true &&
            await userTermsAndConditions.signedConsent == true &&
            await userTermsAndConditions.agreedPrivacy == true) {
          return true;
          //Show home view
        }
        // else {
        //   //Get.offNamed(Routes.HOME_VIEW);
        //   return false;
        //   //show default screen(Home view)
        // }
      }
      return false;
    } catch (e) {
      log("Something went wrong $e");
      log("UserInfo not found");
      return false;
    }
  }

  //store accepted termsAndCondition
  //show error message if all terms and condition are not check
  //else navigate to Home view
  Future<void> acceptTerms() async {
    //instance of userService
    if (ageCompliant.value == true &&
        signedConsent.value == true &&
        agreedPrivacy.value == true) {
      //set errorMsg to false
      errorMsg.value = false;

      //store user accepted term and conditions
      bool success = await _userService.storeTermsAndConditions(
          termsAndConditions: TermsAndConditions(
              ageCompliant: ageCompliant.value,
              signedConsent: signedConsent.value,
              agreedPrivacy: agreedPrivacy.value));
      if (success) {
        await _userService.setNewUserStatus();

        // //store utility data
        // await _localStorageInstance.storeCountry();
        // await _localStorageInstance.storeProfAss();
        // await _localStorageInstance.storeCert();
        // await _localStorageInstance.storePublicKey();
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
    //init storageController
    _initializeStorageController();
    // if (await isTermsAccepted() == true) {
    //   return Get.offNamed(Routes.HOME_VIEW);
    // } else {
    //   //store utility data
    //   await _localStorageInstance.storeCountry();
    //   await _localStorageInstance.storeProfAss();
    //   await _localStorageInstance.storeCert();
    //   await _localStorageInstance.storePublicKey();
    //   return;
    // }

    //check if terms and condition were previously agreed
    //await checkExistingTerms();
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
    //close storageController after use
  }
}
