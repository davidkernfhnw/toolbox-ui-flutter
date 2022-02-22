import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_utility_service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

const String CONSENT_FORM = 'https://project.cyber-geiger.eu/contact.html';
const String PRIVACY_POLICY =
    'https://project.cyber-geiger.eu/privacypolicy.html';

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
  Rx<int> isRadioSelected = 0.obs;

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
        //redirect to setting view
        Get.offNamed(Routes.SETTINGS_VIEW);
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
    await _geigerUtilityData.storeCerts();
    await _geigerUtilityData.storeProfAss();
    await _geigerUtilityData.setPublicKey();
  }

  void launchConsentUrl() async {
    if (!await launch(CONSENT_FORM)) throw 'Could not launch $CONSENT_FORM';
  }

  void launchPrivacyUrl() async {
    if (!await launch(PRIVACY_POLICY)) throw 'Could not launch $PRIVACY_POLICY';
  }

  @override
  void onInit() async {
    //init storageController
    await _initializeStorageController();
    _loadUtilityData();
    super.onInit();
  }

  @override
  void onReady() async {
    await _userService.storeUserConsent();
    await _userService.storeDoNotShareConsent(doNotShare: 0);
    await _userService.storeReplicateConsent(replicateData: 1);

    super.onReady();
  }
}
