import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/consent.dart';
import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/data/model/language.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';
import 'package:geiger_toolbox/app/data/model/terms_and_conditions.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/user_service.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';

import 'package:geiger_toolbox/app/translation/suppored_language.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  //instance of SettingsController
  static final SettingsController instance = Get.find<SettingsController>();

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
  var currentCountry = "Switzerland".obs;
  var currentDeviceName = "".obs;
  var isSuccess = true.obs;

  List certBaseOnCountrySelected = [].obs;
  List profAssBaseOnCountrySelected = [].obs;
  List c = [].obs;

  //list of supported languages
  List<Language> languages = SupportedLanguage.languages;
  //list of partner countries
  //Todo: store in geiger localStorage
  List<String> countries = ["Switzerland", "Romania", "Netherlands"];
  //list of professional association
  //Todo: store in geiger localStorage
  List<Partner> _profAss = [
    Partner(
      location: Country(name: "Switzerland"),
      names: [
        "Swiss Yoga Association",
        "Coiffure Suisse",
        "Swiss SME Association"
      ],
    ),
    Partner(
      location: Country(name: "Romania"),
      names: ["Romania Association"],
    ),
    Partner(
      location: Country(name: "Netherlands"),
      names: ["Netherlands Association"],
    )
  ];
  //list of cert
  //Todo: store in geiger localStorage
  List<Partner> _cert = [
    Partner(
        location: Country(name: "Switzerland"), names: ["NCSC Switzerland"]),
    Partner(location: Country(name: "Romania"), names: ["CERT Romania"]),
    Partner(
        location: Country(name: "Netherlands"),
        names: ["Digital Trust Centre Netherlands"])
  ];

  //update language
  onChangeLanguage(String? language) {
    Locale locale = new Locale(language!);
    //update language ui
    Get.updateLocale(locale);
    //update language
    selectedLanguage.value = language;
  }

  //update supervisor
  onChangeOwner(bool owner) {
    //update ui
    supervisor.value = owner;
  }

  //update country
  //default is switzerland
  onChangedCountry([Object? country = "Switzerland"]) {
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
    userInfo.value.userName = value;
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
    userInfo.supervisor = supervisor.value;
    userInfo.language = selectedLanguage.value;
    userInfo.country = currentCountry.value;
    userInfo.cert = currentCert.value;
    userInfo.profAss = currentProfAss.value;

    _updateUser(userInfo);
    if (isSuccess.value) {
      log("UserInfo: Updated Successfully");
    }
  }

  void _showProfAssBaseOnCountry(String country) {
    Partner selectedProfAss =
        _profAss.firstWhere((Partner element) => country == element.location);
    //for debug purpose
    log(selectedProfAss.names.toString());
    //updates
    profAssBaseOnCountrySelected = selectedProfAss.names;
    currentProfAss.value = profAssBaseOnCountrySelected.first;
  }

  void _showCerBasedOnCountry(String country) {
    //show list of cert base on country selected
    Partner selectedCert =
        _cert.firstWhere((Partner element) => country == element.location);

    //update observable variable
    certBaseOnCountrySelected = selectedCert.names;
    currentCert.value = certBaseOnCountrySelected.first;

    //for debugging purpose
    log(certBaseOnCountrySelected.toString());
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

  //initial storageController
  _initData() async {
    _userService = UserService(await _localStorage.getStorageController);
    userInfo.value = (await _userService.getUserInfo)!;

    //init value in ui
    supervisor.value = userInfo.value.supervisor;
    c.addAll(countries);

    //default country
    //Todo: auto get country by location
    if (userInfo.value.country != null) {
      onChangedCountry(userInfo.value.country);
      //for debugging purpose
      log(certBaseOnCountrySelected.toString());
    } else {
      onChangedCountry();
    }
    //language
    onChangeLanguage(userInfo.value.language);

    if (userInfo.value.deviceOwner!.name == null) {
      userInfo.value.deviceOwner!.name = await _getDeviceName;
    }
    userInfo.value.deviceOwner!.type = await _getDeviceType;
    currentDeviceName.value = userInfo.value.deviceOwner!.name!;

    //init for ui
    if (userInfo.value.country != null &&
        userInfo.value.profAss != null &&
        userInfo.value.cert != null) {
      currentCountry.value = userInfo.value.country!;
      currentProfAss.value = userInfo.value.profAss!;
      currentCert.value = userInfo.value.cert!;
    }
    log("cert current: " + currentCert.value);

    log("userInfo: ${userInfo.value}");
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
    await _initData();
  }
}

//Done userName changes to default when dropdown changes
//Done refactor to use already update services
//Todo store countries, cert, profAss list in localstorage and retrieve them
//Done add update userinfo
