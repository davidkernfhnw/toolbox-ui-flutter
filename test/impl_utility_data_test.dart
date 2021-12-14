// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/impl_utility_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/src/locale.dart';

void main() {
  final StorageController storageController =
      GenericController("test", DummyMapper("testdb"));

  ImplUtilityData implUtilityData = ImplUtilityData(storageController);
  final Locale deCh = Locale.parse("de-ch");
  group("ImplUtilityData test", () {
    setUp(() async {
      //store countries
      // await implUtilityData.storeCountries(
      //   locale: Locale.parse("en"),
      //   countries: [
      //     Country(name: "Switzerland"),
      //     Country(name: "Netherlands"),
      //     Country(name: "Romania")
      //   ],
      // );
    });

    test("test getCountries when not stored", () async {
      List<Country> c = await implUtilityData.getCountries();
      expect(c, isEmpty);
    });

    test("test storeCountries in multiple locale", () async {
      await implUtilityData
          .storeCountries(locale: Locale.parse("en"), countries: [
        Country(name: "switzerland"),
        Country(name: "netherlands"),
        Country(name: "romania")
      ]);

      // await implUtilityData
      //     .storeCountries(locale: Locale.parse("nl-nl"), countries: [
      //   Country(name: "Switzerland"),
      //   Country(name: "Netherlands"),
      //   Country(name: "Romania")
      // ]);
      //
      // await implUtilityData.storeCountries(countries: [
      //   Country(name: "Switzerland in de"),
      //   Country(name: "Netherlands in de"),
      //   Country(name: "Romania sin de")
      // ], locale: Locale.parse("de-de"));
    });
    test("test getCountries when stored", () async {
      List<Country> c = await implUtilityData.getCountries();
      print(c);
      expect(c, isNotEmpty);
    });

    test("test getCountries with locale", () async {
      List<Country> c = await implUtilityData.getCountries(locale: "en");
      print(c.first.name);
      expect(c, isNotEmpty);
    });

    test("test storeCert without locale", () async {
      List<Partner> _cert = [];

      List<Country> countries = await implUtilityData.getCountries();
      print(countries);

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

        _cert.add(Partner(
            location: n, names: ["Digital Trust Centre Netherlands", "CIA"]));

        _cert.add(Partner(location: r, names: ["CERT Romania"]));
      }

      bool result = await implUtilityData.storeCert(certs: _cert);
      print("************");
      print("$result");
      expect(result, isTrue);
    });

    // test("test storeCert with locale", () async {
    //   List<Partner> _cert = [];
    //
    //   // await implUtilityData.storeCountries(countries: [
    //   //   Country(name: "Switzerland"),
    //   //   Country(name: "Netherlands"),
    //   //   Country(name: "Romania")
    //   // ], locale: Locale.parse("en"));
    //
    //   List<Country> countries =
    //       await implUtilityData.getCountries(locale: "de-ch");
    //   print(countries.first.name);
    //
    //   //filter countries
    //   Country s =
    //       countries.firstWhere((element) => element.name == "Switzerland");
    //
    //   Country n =
    //       countries.firstWhere((element) => element.name == "Netherlands");
    //
    //   Country r = countries.firstWhere((element) => element.name == "Romania");
    //
    //   var exist = countries.where((element) => element.name == "Switzerland");
    //   //loop once
    //   for (Country country in exist) {
    //     _cert.add(Partner(location: s, names: ["NCSC Switzerland"]));
    //
    //     _cert.add(
    //         Partner(location: n, names: ["Digital Trust Centre Netherlands-"]));
    //
    //     _cert.add(Partner(location: r, names: ["CERT Romania?"]));
    //   }
    //
    //   bool result = await implUtilityData.storeCert(certs: _cert, locale: deCh);
    //   print("************");
    //   print("$result");
    //   expect(result, isTrue);
    //});

    test("test getCert without locale", () async {
      print("********");
      List<Partner> certs = await implUtilityData.getCert();
      print(certs);
      expect(
        certs,
        isNotEmpty,
      );
    });

    test("test getProfessionAssociation when not stored", () async {
      List<Partner> profAss = await implUtilityData.getProfessionAssociation();
      expect(profAss, isEmpty);
    });

    test("test storeProfessionAssociation", () async {
      List<Partner> profAss = [];
      List<Country> countries = await implUtilityData.getCountries();

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

      bool result = await implUtilityData.storeProfessionAssociation(
          professionAssociation: profAss);
      expect(result, isTrue);
    });
    test("test getProfessionAssociation when stored", () async {
      List<Partner> profAss = await implUtilityData.getProfessionAssociation();
      expect(profAss, isNotEmpty);
    });
  });
  // test(
  //     '20211208 - issue #29 (can\'t retrieve value stored in a different language)',
  //     () async {
  //   // create empty datastore
  //
  //   // Make sure that parent node exists
  //   Node threatsNode = NodeImpl(":Global:threats", "testowner");
  //   await storageController.addOrUpdate(threatsNode);
  //
  //   Future<void> setGlobalThreatsNode(
  //       Locale locale, List<String> threats) async {
  //     Node n;
  //     NodeValue? _nodeValue;
  //     // create threats
  //
  //     for (String e in threats) {
  //       // get current node (or create if non existent)
  //       try {
  //         n = await storageController.get(':Global:threats:${e}');
  //         _nodeValue = await n.getValue('name');
  //         _nodeValue!.setValue(e, locale);
  //       } on StorageException {
  //         n = NodeImpl(':Global:threats:${e}', 'testowner');
  //         _nodeValue = NodeValueImpl("name", e);
  //       }
  //
  //       // create node
  //       await n.addOrUpdateValue(_nodeValue);
  //       await storageController.addOrUpdate(n);
  //       print(n.toString());
  //     }
  //   }
  //
  //   Future<List<String>> getThreats([String language = "en"]) async {
  //     List<String> t = [];
  //     List<Node> _node = await storageController
  //         .search(SearchCriteria(searchPath: ":Global:threats"));
  //     for (Node element in _node) {
  //       if (element.parentPath == ":Global:threats") {
  //         t.add((await element.getValue('name'))!.getValue(language)!);
  //       }
  //     }
  //     return t;
  //   }

  // await implUtilityData
  //     .storeCountries(locale: Locale.parse("en"), countries: [
  //   Country(name: "Switzerland"),
  //   Country(name: "Netherlands"),
  //   Country(name: "Romania")
  // ]);
  //
  // await implUtilityData
  //     .storeCountries(locale: Locale.parse("nl-nl"), countries: [
  //   Country(name: "Switzerland"),
  //   Country(name: "Netherlands"),
  //   Country(name: "Romania")
  // ]);
  //
  // //write values to store
  // await setGlobalThreatsNode(Locale.parse("en"), ["phishing", "malware"]);
  // await setGlobalThreatsNode(
  //     Locale.parse("de-ch"), ["phishing in de", "malware in de"]);
  // await setGlobalThreatsNode(
  //     Locale.parse("nl-nl"), ["phishing in nl", "malware in nl"]);
  //
  // expect('${await getThreats("de-ch")}', '[phishing in de, malware in de]');
  // expect('${await getThreats("nl-nl")}', '[phishing in nl, malware in nl]');
  // expect('${await getThreats("en")}', '[phishing, malware]');
  //});
}
