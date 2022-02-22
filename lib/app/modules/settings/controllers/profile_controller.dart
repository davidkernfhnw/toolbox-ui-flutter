import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/consent.dart';
import 'package:geiger_toolbox/app/model/country.dart';
import 'package:geiger_toolbox/app/model/language.dart';
import 'package:geiger_toolbox/app/model/professional_association.dart';
import 'package:geiger_toolbox/app/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/model/user.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_utility_service.dart';
import 'package:geiger_toolbox/app/translation/suppored_language.dart';
import 'package:get/get.dart';

import '../../../model/cert.dart';

class ProfileController extends GetxController {
  //instance of SettingsController
  static final ProfileController instance = Get.find<ProfileController>();

  late final StorageController _storageController;
  //userService
  late final GeigerUserService _userService;
  late final GeigerUtilityService _geigerData;

  //getting instance of localStorageController
  final LocalStorageController _localStorage = LocalStorageController.instance;

  //initialize user object to be observable
  Rx<User> userInfo = User(
    consent: Consent(),
    termsAndConditions: TermsAndConditions(),
  ).obs;

  //observable variables for react Ui
  //get default language from device
  var selectedLanguage = Get.locale!.languageCode.obs;
  var currentCert = "".obs;
  var currentProfAss = "".obs;
  var supervisor = false.obs;
  var currentCountryId = "cd258b40-4dc1-486a-b000-eb59e71e7484".obs;
  var currentDeviceName = "".obs;
  var currentUserName = "".obs;
  var isSuccess = true.obs;
  var isLoading = false.obs;
  List<Cert> certBaseOnCountrySelected = <Cert>[].obs;
  List<ProfessionalAssociation> profAssBaseOnCountrySelected =
      <ProfessionalAssociation>[].obs;
  List<Country> currentCountries = <Country>[].obs;

  //list of supported languages
  List<Language> languages = SupportedLanguage.languages;
  //list of professional association
  late List<ProfessionalAssociation> _profAss;
  //list of cert
  late List<Cert> _cert;

  late Locale _locale;

  //update language
  onChangeLanguage(String? language) async {
    _locale = Locale(language!);
    //update language
    selectedLanguage.value = language;
    //update language ui
    Get.updateLocale(_locale);

    //update data list
    await _getData(language);

    //set default country
    onChangedCountry(currentCountryId.value);

    userInfo.value.language = selectedLanguage.value;
  }

  //update supervisor
  onChangeOwner(bool owner) {
    supervisor.value = owner;
  }

  //update country
  //default is switzerland
  onChangedCountry(dynamic country) {
    //update country
    currentCountryId.value = country.toString();

    //show list of cert base on country selected
    _showCertBasedOnCountry(country.toString());

    //show list of profAss base on country selected
    _showProfAssBaseOnCountry(country.toString());

    //for debugging purpose
    log(certBaseOnCountrySelected.toString());
  }

  //update currentCert
  onChangedCert(dynamic cert) {
    currentCert.value = cert;

    //for debugging purpose
    log(currentCert.value.toString());
  }

  //update currentProfAss
  onChangedProfAss(dynamic profAss) {
    currentProfAss.value = profAss;

    //for debugging purpose
    log(currentProfAss.value.toString());
  }

  //update userName
  onChangeUserName(String value) {
    currentUserName.value = value;
  }

  //update CurrentDeviceName
  onChangeDeviceName(String value) {
    currentDeviceName.value = value;
  }

  //validate UserName
  //username must not be empty
  String? validateUserName(String? value) {
    if (value!.isEmpty) {
      return "Please Enter your Name";
    } else {
      return null;
    }
  }

  //validate DeviceName
  //Devicename must not be empty
  String? validateDeviceName(String? value) {
    if (value!.isEmpty) {
      return "Please Enter Device Name";
    } else {
      return null;
    }
  }

  String? validateCert(String? value) {
    if (value!.isEmpty) {
      return "";
    } else {
      return null;
    }
  }

  String? validateProfAss(String? value) {
    if (value!.isEmpty) {
      return "";
    } else {
      return null;
    }
  }

  //call when the update button  is pressed
  void updateUserInfo(User userInfo) {
    //check dis

    userInfo.userName = currentUserName.value;
    userInfo.deviceOwner!.name = currentDeviceName.value;
    userInfo.supervisor = supervisor.value;

    userInfo.country = currentCountryId.value;
    userInfo.cert = currentCert.value;
    userInfo.profAss = currentProfAss.value;
    //update language ui
    Get.updateLocale(_locale);
    _updateUser(userInfo);
    if (isSuccess.value) {
      log("UserInfo: Updated Successfully");
    }
  }

  _updateUser(User userInfo) async {
    bool success = await _userService.updateUserInfo(userInfo);
    if (success) {
      isSuccess.value = success;
      log("${await _userService.getUserInfo}");
    } else {
      isSuccess.value = success;
    }
  }

  void _showProfAssBaseOnCountry(String countryId) {
    List<ProfessionalAssociation> selectedProfAss = _profAss
        .where((ProfessionalAssociation element) =>
            countryId == element.locationId)
        .toList();
    //for debug purpose
    log(selectedProfAss.first.name.toString());
    //updates
    profAssBaseOnCountrySelected = selectedProfAss;
    currentProfAss.value = profAssBaseOnCountrySelected.first.name!;
  }

  void _showCertBasedOnCountry(String countryId) {
    //show list of cert base on country selected
    List<Cert> selectedCert =
        _cert.where((Cert element) => countryId == element.locationId).toList();

    log("selectedCert => $selectedCert");
    //update observable variable
    certBaseOnCountrySelected = selectedCert;
    currentCert.value = certBaseOnCountrySelected.first.name!;

    //for debugging purpose
    log(certBaseOnCountrySelected.toString());
  }

  //init storageController
  Future<void> _initStorageController() async {
    _storageController = await _localStorage.getStorageController;
    _geigerData = GeigerUtilityService(_storageController);
    _userService = GeigerUserService(_storageController);
  }

  //init util data
  Future<void> _getData(String language) async {
    isLoading.value = true;
    currentDeviceName.value = await _userService.getDeviceName;
    currentCountries = await _geigerData.getCountries(language: language);
    _cert = await _geigerData.getPartnerCert(language: language);
    log("cert ==> $_cert");
    _profAss = await _geigerData.getPartnerProfAss(language: language);
    log("Prof ass ==> $_profAss");
    isLoading.value = false;
  }

  Future<void> _initialUserInfo() async {
    User? user = await _userService.getUserInfo;
    if (user != null) {
      userInfo.value = user;
    }
  }

  //initial User Data
  Future<void> _initUserData() async {
    isLoading.value = true;

    //init value in ui
    supervisor.value = userInfo.value.supervisor;

    currentDeviceName.value = userInfo.value.deviceOwner!.name!;

    //init for ui
    if (userInfo.value.country != null &&
        userInfo.value.profAss != null &&
        userInfo.value.cert != null) {
      currentCountryId.value = userInfo.value.country!;
      currentProfAss.value = userInfo.value.profAss!;
      currentCert.value = userInfo.value.cert!;
    }
    if (userInfo.value.userName != null) {
      currentUserName.value = userInfo.value.userName!;
    }

    //default country
    //Todo: auto get country by location
    if (userInfo.value.country != null) {
      onChangedCountry(userInfo.value.country!);
    } else {
      onChangedCountry(currentCountryId.value);
    }

    //set language
    log("cert current: ${currentCert.value}");
    log("country: ${currentCountryId.value}");
    log("countries: ${currentCountries}");
    log("list of ProfAss => ${profAssBaseOnCountrySelected}");
    log("profAss: ${currentProfAss.value}");
    log("userInfo: ${userInfo.value}");
    log("CurrentUserName :${currentUserName.value}");

    isLoading.value = false;
  }

  @override
  void onInit() async {
    await _initStorageController();
    await _initialUserInfo();
    await _getData(userInfo.value.language);
    await _initUserData();

    log("DUMP ON Profile ${await _storageController.dump(":Global:professionAssociation")}");

    super.onInit();
  }
}
