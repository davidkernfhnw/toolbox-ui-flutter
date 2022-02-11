import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:get/get.dart';

import '../../../model/terms_and_conditions.dart';
import '../../../model/user.dart';
import '../../../routes/app_routes.dart';

class DataProtectionController extends GetxController {
  //instance of DataController
  static final DataProtectionController instance =
      Get.find<DataProtectionController>();

  //getting instance of localStorageController
  final LocalStorageController _localStorage = LocalStorageController.instance;

  late final StorageController _storageController;
  late final GeigerUserService _userService;
  //init storageController
  Future<void> _initStorageController() async {
    _storageController = await _localStorage.getStorageController;
    _userService = GeigerUserService(_storageController);
  }

  var _dataAccess = false.obs;
  var isLoading = false.obs;
  var isLoadingServices = false.obs;

  bool get getDataAccess {
    return _dataAccess.value;
  }

  void set setDataAccess(bool value) {
    _dataAccess.value = value;
  }

  Future<bool> updateDataAccess(bool value) async {
    isLoading.value = false;
    bool result = await _storeDataAccess(value);
    if (value) {
      _dataAccess.value = value;
    } else {
      _dataAccess.value = false;
    }
    log("DataAccess status ${_dataAccess.value}");
    isLoading.value = false;
    return result;
  }

  Future<void> _getUserConsent() async {
    bool? access = await _userService.getUserConsentDataAccess;
    if (access != null) {
      _dataAccess.value = access;
    }
  }

  Future<bool> _storeDataAccess(bool value) async {
    bool success =
        await _userService.updateUserConsentDataAccess(dataAccess: value);
    return success;
  }

  //check if terms and condition values is true in the localstorage
  // and navigate to Setting(screen)
  //if false navigate to TermAndCondition view(screen).
  Future<bool> _isTermsAccepted() async {
    try {
      //get user Info
      User? userInfo = await _userService.getUserInfo;

      // assign user term and condition
      TermsAndConditions userTermsAndConditions = userInfo!.termsAndConditions;
      //check if true and return home view (screen)
      if (await userTermsAndConditions.ageCompliant == true &&
          await userTermsAndConditions.signedConsent == true &&
          await userTermsAndConditions.agreedPrivacy == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("UserInfo not found");
      return false;
    }
  }

  //Todo: take this method to data_protection_controller
  //check if termsAndConditions were accepted
  // redirect to termAndCondition view if false else
  // then check for userConsent if true
  // redirect to Home view
  //else remain in setting screen

  Future<bool> _redirect() async {
    isLoadingServices.value = true;
    bool checkTerms = await _isTermsAccepted();

    if (checkTerms == false) {
      await Get.offNamed(Routes.TERMS_AND_CONDITIONS_VIEW);
      isLoadingServices.value = false;
      return false;
    } else {
      bool? result = await _userService.checkUserConsent();

      if (result!) {
        await Get.offNamed(Routes.HOME_VIEW);
        isLoadingServices.value = false;
        return false;
      } else {
        isLoadingServices.value = false;
        return true;
      }
    }
  }

  @override
  void onInit() async {
    await _initStorageController();
    bool redirect = await _redirect();
    if (redirect) {
      await _getUserConsent();
      log("DUMP ON data protection ${await _storageController.dump(":Global:cert")}");
    }
    super.onInit();
  }
}
