// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';
import 'package:geiger_toolbox/app/routes/app_pages.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/impl_utility_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/src/locale.dart';

void main() {
  final StorageController storageController =
      GenericController("test", DummyMapper("testdb"));

  ImplUtilityData implUtilityData = ImplUtilityData(storageController);
  final Locale deCh = Locale.parse("de-ch");
  group("ImplUtilityData test", () {
    test("test getCountries when not stored", () async {
      List<Country> c = await implUtilityData.getCountries();
      expect(c, isEmpty);
    });

    test("test storeCountries without locale", () async {
      bool result = await implUtilityData.storeCountries(countries: [
        Country(name: "Switzerland"),
        Country(name: "Netherlands"),
        Country(name: "Romania")
      ]);
      expect(result, isTrue);
    });
    test("test getCountries without when stored", () async {
      List<Country> c = await implUtilityData.getCountries();
      print(c);
      expect(c, isNotEmpty);
    });

    test("test storeCountries with locale", () async {
      bool result =
          await implUtilityData.storeCountries(locale: deCh, countries: [
        Country(name: "Switzerland"),
        Country(name: "Netherlands"),
        Country(name: "Romania")
      ]);
      expect(result, isTrue);
    });
    test("test getCountries with locale", () async {
      List<Country> c = await implUtilityData.getCountries(locale: "de-ch");
      print(c);
      expect(c, isNotEmpty);
    });

    test("test storeCert without locale", () async {
      List<Partner> _cert = [];

      List<Country> countries = await implUtilityData.getCountries();

      //filter countries
      Country s =
          countries.firstWhere((element) => element.name == "Switzerland");

      Country n =
          countries.firstWhere((element) => element.name == "Netherlands");

      Country r = countries.firstWhere((element) => element.name == "Romania");

      var exist = countries.where((element) => element.name == "Switzerland");
      //loop once
      for (Country country in exist) {
        _cert.add(Partner(location: s, names: ["NCSC Switzerland"]));

        _cert.add(
            Partner(location: n, names: ["Digital Trust Centre Netherlands"]));

        _cert.add(Partner(location: r, names: ["CERT Romania"]));
      }

      bool result = await implUtilityData.storeCert(certs: _cert);
      print("************");
      print("$result");
      expect(result, isTrue);
    });

    test("test storeCert with locale", () async {
      List<Partner> _cert = [];

      //store countries
      await implUtilityData.storeCountries(countries: [
        Country(name: "Switzerland"),
        Country(name: "Netherlands"),
        Country(name: "Romania")
      ]);
      List<Country> countries =
          await implUtilityData.getCountries(locale: "de-CH");

      //filter countries
      Country s =
          countries.firstWhere((element) => element.name == "Switzerland");

      Country n =
          countries.firstWhere((element) => element.name == "Netherlands");

      Country r = countries.firstWhere((element) => element.name == "Romania");

      var exist = countries.where((element) => element.name == "Switzerland");
      //loop once
      for (Country country in exist) {
        _cert.add(Partner(location: s, names: ["NCSC Switzerland"]));

        _cert.add(
            Partner(location: n, names: ["Digital Trust Centre Netherlands"]));

        _cert.add(Partner(location: r, names: ["CERT Romania"]));
      }

      bool result = await implUtilityData.storeCert(certs: _cert, locale: deCh);
      print("************");
      print("$result");
      print(countries);
      expect(result, isTrue);
    });
  });
}
