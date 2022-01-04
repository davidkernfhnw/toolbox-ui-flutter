import 'package:geiger_localstorage/src/storage_controller.dart';
import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';
import 'package:geiger_toolbox/app/services/helpers/implementation/impl_utility_data.dart';
import 'package:intl/src/locale.dart';

class GeigerData extends ImplUtilityData {
  GeigerData(StorageController storageController) : super(storageController);

  //store list of countries
  // they are store in lowerCase
  Future<void> storeCountry() async {
    await storeCountries(countries: [
      Country(name: "Switzerland"),
      Country(name: "Netherlands"),
      Country(name: "Romania")
    ], locale: Locale.parse("en"));
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
      _cert.add(Partner(location: s, names: ["NCSC Switzerland"]));

      _cert.add(
          Partner(location: n, names: ["Digital Trust Centre Netherlands"]));

      _cert.add(Partner(location: r, names: ["CERT Romania"]));
    }
    //store cert
    await storeCert(certs: _cert);
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
    await storeProfessionAssociation(professionAssociation: profAss);
  }

  //store public key
  Future<void> setPublicKey() async {
    await storePublicKey();
  }
}
