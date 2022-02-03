import 'package:geiger_localstorage/src/storage_controller.dart';
import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';

import '../abstract/geiger_utility_helper.dart';

class GeigerUtilityService extends GeigerUtilityHelper {
  GeigerUtilityService(StorageController storageController)
      : super(storageController);

  //store list of countries
  // they are store in lowerCase and english
  Future<void> storeCountry() async {
    await storeCountries(countries: [
      Country(name: "Switzerland", id: "cd258b40-4dc1-486a-b000-eb59e71e7484"),
      Country(name: "Netherlands", id: "4b5e6eba-3801-45bd-9485-86378c4b4320"),
      Country(name: "Romania", id: "e60c88f2-7ab7-4e9f-bd26-5d2a062b4af9")
    ]);
  }

  //store list of CERT base on countries
  //available in the localStorage-
  Future<void> storeCerts() async {
    List<Partner> _cert = [];
    //get countries store in localStore
    List<Country> countries = await getCountries();

    //filter countries
    Country s =
        countries.firstWhere((element) => element.name == "switzerland");

    Country n =
        countries.firstWhere((element) => element.name == "netherlands");

    Country r = countries.firstWhere((element) => element.name == "romania");

    var exist = countries.where((element) => element.name == "switzerland");
    // ignore: unused_local_variable
    for (Country country in exist) {
      _cert.add(Partner(
          location: s,
          names: ["NCSC Switzerland"],
          id: "1d79a419-f2cc-4f39-b216-ee84c25d858f"));

      _cert.add(Partner(
          location: n,
          names: ["Digital Trust Centre Netherlands"],
          id: "e1274119-1b2c-4703-8c2e-b0b1a0b0f01a"));

      _cert.add(Partner(
          location: r,
          names: ["CERT Romania"],
          id: "2ce49c82-9b22-417a-a4a0-83c72ab34840"));
    }
    //store cert
    storeCert(certs: _cert);
  }

  //store list of professional association base on countries
  //available in the localStorage-
  Future<void> storeProfAss() async {
    List<Partner> profAss = [];
    List<Country> countries = await getCountries();

    //filter countries
    Country s =
        countries.firstWhere((element) => element.name == "switzerland");

    Country n =
        countries.firstWhere((element) => element.name == "netherlands");

    Country r = countries.firstWhere((element) => element.name == "romania");

    var exist = countries.where((element) => element.name == "switzerland");
    // ignore: unused_local_variable
    for (Country country in exist) {
      profAss.add(Partner(
          location: s,
          names: [
            "Swiss Yoga Association",
            "Coiffure Suisse",
            "Swiss SME Association"
          ],
          id: "f2a30f42-37c3-4f54-9dd9-97ffe923aa76"));
      profAss.add(Partner(
          location: r,
          names: ["Romania Association"],
          id: "ff409674-11a3-41b6-9823-a64b4469c034"));
      profAss.add(Partner(
          location: n,
          names: ["Netherlands Association"],
          id: "ea3afb16-6a57-4962-92b5-b054b2683c07"));
    }
    storeProfessionAssociation(professionAssociation: profAss);
  }

  //store public key
  Future<void> setPublicKey() async {
    await storePublicKey();
  }
}
