import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/language.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';
import 'package:geiger_toolbox/app/services/local_storage.dart';
//import 'package:geiger_toolbox/app/services/local_storage.dart';
import 'package:geiger_toolbox/app/translation/suppored_language.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  //instance
  static SettingsController to = Get.find();
  dummy.UserNode? _userNode;
  StorageController? _storageController;
  LocalStorageController _localStorage = LocalStorageController.to;

  TextEditingController userName = TextEditingController();
  final TextEditingController deviceName = TextEditingController();

  //final formKey = GlobalKey<FormBuilderState>();

  //user object observable
  var userInfo = dummy.User(
          consent: dummy.Consent(),
          termsAndConditions: dummy.TermsAndConditions(),
          deviceOwner: dummy.Device())
      .obs;

  //language selection
  var selectedLanguage = Get.locale!.languageCode.obs;
  var currentCert = "NCSC Switzerland".obs;
  var currentProfAss = "Swiss Yoga Association".obs;
  var supervisor = false.obs;

  //list of supported languages
  List<Language> languages = SupportedLanguage.languages;
  //list of partner countries
  List<String> countries = ["Switzerland", "Romania", "Netherlands"];
  //list of cert
  List<Partner> _profAss = [
    Partner(
      country: "Switzerland",
      names: [
        "Swiss Yoga Association",
        "Coiffure Suisse",
        "Swiss SME Association"
      ],
    ),
    Partner(
      country: "Romania",
      names: ["Romania Association"],
    ),
    Partner(
      country: "Netherlands",
      names: ["Netherlands Association"],
    )
  ];
  List<Partner> _cert = [
    Partner(country: "Switzerland", names: ["NCSC Switzerland"]),
    Partner(country: "Romania", names: ["CERT Romania"]),
    Partner(country: "Netherlands", names: ["Digital Trust Centre Netherlands"])
  ];

  List certBaseOnCountrySelected = [].obs;
  List profAssBaseOnCountrySelected = [].obs;

  onChangeLanguage(String? language) {
    Locale locale = new Locale(language!);
    Get.updateLocale(locale);
    selectedLanguage.value = language;
    userInfo.value.language = language;
    log(userInfo.value.language.toString());
  }

  onChangeOwner(bool owner) {
    userInfo.value.supervisor = owner;
    supervisor.value = userInfo.value.supervisor;
    log(userInfo.value.supervisor.toString());
  }

  //set CERT AND professionAssociation base on country selection
  onChangedCountry(String? country) {
    Partner selectedCert =
        _cert.firstWhere((Partner element) => country == element.country);

    //updates
    certBaseOnCountrySelected = selectedCert.names;
    currentCert.value = certBaseOnCountrySelected.first;
    userInfo.value.country = country;

    log(userInfo.value.country.toString());
    log(certBaseOnCountrySelected.toString());

    Partner selectedProfAss =
        _profAss.firstWhere((Partner element) => country == element.country);
    log(selectedProfAss.names.toString());
    //updates
    profAssBaseOnCountrySelected = selectedProfAss.names;
    currentProfAss.value = profAssBaseOnCountrySelected.first;
  }

  onChangedCert(dynamic cert) {
    currentCert.value = cert;
    log(currentCert.value.toString());
  }

  onChangedProfAss(dynamic profAss) {
    currentProfAss.value = profAss;
    log(currentProfAss.value.toString());
  }

  //initial storageController
  _init() async {
    _storageController = await _localStorage.storageController;
    _userNode = await dummy.UserNode(_storageController!);
  }

  Future<dummy.User> get getUserDetails async {
    return await _setUserDetails();
  }

  //get user Details from localstorage and pass it to screen
  Future<dummy.User> _setUserDetails() async {
    dummy.User user = await _getUser;
    userInfo.value.userId = user.userId;
    userInfo.value.userName = user.userName ?? "";
    userInfo.value.deviceOwner.name = await _getDeviceName;
    userInfo.value.deviceOwner.type = _getDeviceType;
    userInfo.value.supervisor = user.supervisor;
    userInfo.value.language = user.language;
    userInfo.value.country = user.country;
    userInfo.value.cert = user.cert;
    userInfo.value.profAss = user.profAss;
    userInfo.value.consent = user.consent;
    userInfo.value.termsAndConditions = user.termsAndConditions;

    dummy.User u = dummy.User(
        userId: userInfo.value.userId,
        userName: userInfo.value.userName,
        deviceOwner: userInfo.value.deviceOwner,
        supervisor: userInfo.value.supervisor,
        language: userInfo.value.language,
        country: userInfo.value.country,
        cert: userInfo.value.cert,
        profAss: userInfo.value.profAss,
        consent: userInfo.value.consent,
        termsAndConditions: userInfo.value.termsAndConditions);
    log(u.toString());
    return u;
  }

  Future<dummy.User> get _getUser async {
    return await _userNode!.getUserInfo;
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
    await _init();
    userInfo.value = await _setUserDetails();
    log(userName.toString());
    log("userInfo: ${userInfo.value}");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    userName.dispose();
    deviceName.dispose();
    await _storageController!.close();

    super.onClose();
  }
}
