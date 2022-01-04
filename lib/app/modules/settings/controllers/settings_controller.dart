import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/consent.dart';
import 'package:geiger_toolbox/app/data/model/language.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_toolbox/app/services/helpers/implementation/geiger_data.dart';
import 'package:geiger_toolbox/app/services/helpers/implementation/impl_utility_data.dart';
import 'package:geiger_toolbox/app/services/helpers/implementation/impl_user_service.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/translation/suppored_language.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  //instance of SettingsController
  static final SettingsController instance = Get.find<SettingsController>();

  late final StorageController _storageController;
  //userService
  late final UserService _userService;
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
  var currentCert = "NCSC Switzerland".obs;
  var currentProfAss = "Swiss Yoga Association".obs;
  var supervisor = false.obs;
  var currentCountry = "".obs;
  var currentDeviceName = "".obs;
  var currentUserName = "".obs;
  var isSuccess = true.obs;

  List certBaseOnCountrySelected = [].obs;
  List profAssBaseOnCountrySelected = [].obs;
  List currentCountries = [].obs;

  //list of supported languages
  List<Language> languages = SupportedLanguage.languages;
  //list of professional association
  late List<Partner> _profAss;
  //list of cert
  late List<Partner> _cert;

  //update language
  onChangeLanguage(String? language) {
    Locale locale = new Locale(language!);
    //update language ui
    Get.updateLocale(locale);
    //update language
    selectedLanguage.value = language;
    //update default language
    userInfo.value.language = selectedLanguage.value;
  }

  //update supervisor
  onChangeOwner(bool owner) {
    supervisor.value = owner;
  }

  //update country
  //default is switzerland
  onChangedCountry([Object? country = "switzerland"]) {
    //update country
    currentCountry.value = country.toString();

    //show list of cert base on country selected
    _showCerBasedOnCountry(country.toString());

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

  //call when the update button  is pressed
  void updateUserInfo(User userInfo) {
    //check dis
    //check dis
    userInfo.supervisor = supervisor.value;
    userInfo.userName = currentUserName.value;
    userInfo.country = currentCountry.value;
    userInfo.cert = currentCert.value;
    userInfo.profAss = currentProfAss.value;

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

  void _showProfAssBaseOnCountry(String country) {
    Partner selectedProfAss = _profAss
        .firstWhere((Partner element) => country == element.location.name);
    //for debug purpose
    log(selectedProfAss.names.toString());
    //updates
    profAssBaseOnCountrySelected = selectedProfAss.names;
    currentProfAss.value = profAssBaseOnCountrySelected.first;
  }

  void _showCerBasedOnCountry(String country) {
    //show list of cert base on country selected
    Partner selectedCert =
        _cert.firstWhere((Partner element) => country == element.location.name);

    //update observable variable
    certBaseOnCountrySelected = selectedCert.names;
    currentCert.value = certBaseOnCountrySelected.first;

    //for debugging purpose
    log(certBaseOnCountrySelected.toString());
  }

  //init storageController
  Future<void> _initStorageController() async {
    _storageController = await _localStorage.getStorageController;
  }

  //init util data
  Future<void> _initialUtilityData() async {
    GeigerData _utilityData = GeigerData(_storageController);
    //Todo fix problem with currentCountries not getting populating on time
    currentCountries.addAll(await _utilityData.getCountries());
    _profAss = await _utilityData.getProfessionAssociation();
    _cert = await _utilityData.getCert();
  }

  //initial User Data
  Future<void> _initUserData() async {
    _userService = UserService(_storageController);
    userInfo.value = (await _userService.getUserInfo)!;
    //init value in ui
    supervisor.value = userInfo.value.supervisor;

    if (userInfo.value.deviceOwner!.name == null &&
        userInfo.value.deviceOwner!.type == null) {
      userInfo.value.deviceOwner!.name = await _getDeviceName;
      currentDeviceName.value = userInfo.value.deviceOwner!.name!;
      userInfo.value.deviceOwner!.type = await _getDeviceType;
    } else {
      currentDeviceName.value = userInfo.value.deviceOwner!.name!;
    }
    //init for ui
    if (userInfo.value.country != null &&
        userInfo.value.profAss != null &&
        userInfo.value.cert != null &&
        userInfo.value.userName != null) {
      currentCountry.value = userInfo.value.country!;
      currentProfAss.value = userInfo.value.profAss!;
      currentCert.value = userInfo.value.cert!;
      currentUserName.value = userInfo.value.userName!;
    } else {
      //currentCountry.value = "Switzerland";

    }

    //default country
    //Todo: auto get country by location
    if (userInfo.value.country != null) {
      onChangedCountry(userInfo.value.country!.toLowerCase());
    } else {
      onChangedCountry();
    }
    //set language
    onChangeLanguage(userInfo.value.language);
    log("cert current: " + currentCert.value);
    log("country: ${currentCountry.value}");
    log("country: ${currentCountries}");
    log("profAss: ${currentProfAss.value}");
    log("userInfo: ${userInfo.value}");
    log("CurrentUserName :${currentUserName.value}");
  }

  //get name of the user device
  Future<String> get _getDeviceName async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.utsname.machine;
    } else if (Platform.isMacOS) {
      return "MacOS";
    } else if (Platform.isWindows) {
      return "Windows";
    } else {
      return "Web";
    }
  }

  //get devicetype
  String get _getDeviceType {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return "IPhone";
    } else if (Platform.isMacOS) {
      return "Mac Book";
    } else if (Platform.isWindows) {
      return "Windows Desktop";
    } else {
      return "Web Browser";
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await _initStorageController();
    await _initialUtilityData();
    await _initUserData();
  }
}
