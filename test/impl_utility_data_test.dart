import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/impl_utility_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

void main() {
  final StorageController storageController =
      GenericController("test", DummyMapper("testdb"));

  ImplUtilityData implUtilityData = ImplUtilityData(storageController);
  group("ImplUtilityData test", () {
    test("test storeCountries", () async {
      bool result = await implUtilityData.storeCountries(countries: [
        Country(name: "Switzerland"),
        Country(name: "Netherlands")
      ]);
      expect(result, isTrue);
    });
  });
}
