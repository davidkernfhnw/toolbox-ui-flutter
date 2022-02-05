import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_utility_service.dart';
import 'package:get/get.dart';

class TermsAndConditionsController extends GetxController {
  //instance of TermsAndConditionController
  static TermsAndConditionsController instance = Get.find();

  //get instance of LocalStorageController
  final LocalStorageController _localStorageInstance =
      LocalStorageController.instance;

  //declaring storageController
  late StorageController _storageController;
  late GeigerUserService _userService;
  late final GeigerUtilityService _geigerUtilityData;

  //initialize _storageController using _localStorage instance
  Future<void> _initializeStorageController() async {
    log("InitialStorageController from TermsAndCondition called");
    _storageController = await _localStorageInstance.getStorageController;
    _userService = GeigerUserService(_storageController);
    _geigerUtilityData = GeigerUtilityService(_storageController);
  }

  // declaring variable for creativeness
  var ageCompliant = false.obs;
  var signedConsent = false.obs;
  var agreedPrivacy = false.obs;
  var errorMsg = false.obs;

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
        //set scanButton has not be pressed to true
        await _userService.setButtonNotPressed();
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

  // //load utility data
  Future<void> _loadUtilityData() async {
    await _geigerUtilityData.storeCountry();
    await _geigerUtilityData.storeProfAss();
    await _geigerUtilityData.storeCerts();
    await _geigerUtilityData.setPublicKey();
  }

  @override
  void onInit() async {
    //init storageController
    await _initializeStorageController();

    super.onInit();
  }

  @override
  void onReady() async {
    _userService.storeUserConsent();
    await _loadUtilityData();
    super.onReady();
  }
}
