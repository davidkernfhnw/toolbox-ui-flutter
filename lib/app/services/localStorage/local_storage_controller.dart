//import 'dart:developer';

import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';
import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
import 'package:get/get.dart';
import 'package:geiger_api/geiger_api.dart';
import 'package:intl/src/locale.dart';

import 'localServices/impl_utility_data.dart';

class LocalStorageController extends GetxController {
  //instance of LocalStorageController
  static LocalStorageController instance = Get.find<LocalStorageController>();
  //get instance of GeigerApiConnector
  GeigerApiConnector _geigerApiConnector = GeigerApiConnector.to;
  late StorageController _storageController;
  late GeigerApi _api;

  late ImplUtilityData _utilityData;
  StorageController get getStorageController {
    return _storageController;
  }

  Future<void> initLocalStorage() async {
    try {
      _api = await _geigerApiConnector.getLocalMaster;
      _storageController = _api.getStorage()!;
      _utilityData = ImplUtilityData(_storageController);
    } catch (e) {
      log("Database Connection Error From LocalStorage: $e");
      rethrow;
    }
  }

  Future<void> storeCountry() async {
    await _utilityData.storeCountries(countries: [
      Country(name: "Switzerland"),
      Country(name: "Netherlands"),
      Country(name: "Romania")
    ], locale: Locale.parse("en"));
  }

  Future<void> storeCert() async {
    List<Partner> _cert = [];
    //get countries store in localStore
    List<Country> countries = await _utilityData.getCountries();

    //filter countries
    Country s =
        countries.firstWhere((element) => element.name == "switzerland");

    Country n =
        countries.firstWhere((element) => element.name == "netherlands");

    Country r = countries.firstWhere((element) => element.name == "romania");

    var exist = countries.where((element) => element.name == "switzerland");
    //loop once
    for (Country country in exist) {
      _cert.add(Partner(location: s, names: ["NCSC Switzerland"]));

      _cert.add(
          Partner(location: n, names: ["Digital Trust Centre Netherlands"]));

      _cert.add(Partner(location: r, names: ["CERT Romania"]));
    }
    //store cert
    await _utilityData.storeCert(certs: _cert);
  }

  Future<void> storeProfAss() async {
    List<Partner> profAss = [];
    List<Country> countries = await _utilityData.getCountries();

    //filter countries
    Country s =
        countries.firstWhere((element) => element.name == "switzerland");

    Country n =
        countries.firstWhere((element) => element.name == "netherlands");

    Country r = countries.firstWhere((element) => element.name == "romania");

    var exist = countries.where((element) => element.name == "switzerland");
    for (Country country in exist) {
      profAss.add(Partner(location: s, names: [
        "Swiss Yoga Association",
        "Coiffure Suisse",
        "Swiss SME Association"
      ]));
      profAss.add(Partner(
        location: r,
        names: ["Romania Association"],
      ));
      profAss.add(Partner(
        location: n,
        names: ["Netherlands Association"],
      ));
    }
    await _utilityData.storeProfessionAssociation(
        professionAssociation: profAss);
  }

  //close geigerApi after user
  @override
  void onClose() async {
    super.onClose();
    await _api.close();
  }
//Todo
// registered storageListener
//listen to plugin
}
