// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/impl_utility_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/src/locale.dart';

void main() {
  final StorageController storageController =
      GenericController("test", DummyMapper("testdb"));

  ImplUtilityData implUtilityData = ImplUtilityData(storageController);
  group("ImplUtilityData test", () {
    test("test getCountries when not stored", () async {
      List<Country> c = await implUtilityData.getCountries();
      expect(c, isEmpty);
    });

    test("test storeCountries", () async {
      bool result = await implUtilityData.storeCountries(countries: [
        Country(name: "Switzerland"),
        Country(name: "Netherlands")
      ]);
      expect(result, isTrue);
    });
    test("test getCountries when stored", () async {
      List<Country> c = await implUtilityData.getCountries();
      print(c);
      expect(c, isNotEmpty);
    });

    test("test storeCountries with locale", () async {
      final Locale locale = Locale.parse("de-ch");
      bool result = await implUtilityData.storeCountries(
          locale: locale,
          countries: [
            Country(name: "Switzerland"),
            Country(name: "Netherlands")
          ]);
      expect(result, isTrue);
    });
    test("test getCountries with locale", () async {
      List<Country> c = await implUtilityData.getCountries(locale: "de-ch");
      print(c);
      expect(c, isNotEmpty);
    });
  });
}
