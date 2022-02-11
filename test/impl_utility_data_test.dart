// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/cert.dart';
import 'package:geiger_toolbox/app/model/country.dart';
import 'package:geiger_toolbox/app/model/professional_association.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/abstract/geiger_utility_abstract.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_utility_service.dart';

void main() {
  final StorageController storageController =
      GenericController("test", DummyMapper("testdb"));

  GeigerUtilityAbstract implUtilityData =
      GeigerUtilityService(storageController);
  //final Locale deCh = Locale.parse("de-ch");
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
      bool r = await implUtilityData.storeCountries(countries: [
        Country(id: "1", name: "switzerland"),
        Country(id: "2", name: "netherlands"),
        Country(id: "3", name: "romania")
      ]);
      expect(r, isTrue);
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
      //   Country(name: "Romania sin de", )
      // ]);
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
      List<Cert> swissCerts = [
        Cert(
            id: "330e1d39-aad3-43ea-9f32-f89fc82899d9",
            name: "NCSC Switzerland")
      ];
      //get countries store in localStore
      List<Country> countries = await implUtilityData.getCountries();

      //filter countries
      Country s =
          countries.firstWhere((element) => element.name == "switzerland");
      for (Cert swissCert in swissCerts) {
        swissCert.locationId = s.id;
        bool result = await implUtilityData.storeCert(cert: swissCert);
        print("************");
        print("$result");
        expect(result, isTrue);
      }
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
      List<Cert> certs = await implUtilityData.getPartnerCert();
      print(certs);
      expect(
        certs,
        isNotEmpty,
      );
    });

    test("test getProfessionAssociation when not stored", () async {
      List<ProfessionalAssociation> profAss =
          await implUtilityData.getPartnerProfAss();
      expect(profAss, isEmpty);
    });

    test("test storeProfessionAssociation", () async {
      List<ProfessionalAssociation> swissProfAss = [
        ProfessionalAssociation(
            id: "8d14468b-30c2-414e-95b1-667844529aa3",
            name: "Swiss Yoga Association"),
        ProfessionalAssociation(
            id: "1f850c91-ba00-4691-90c8-9602b24d8815",
            name: "Coiffure Suisse"),
        ProfessionalAssociation(
            id: "5ea818af-9b8b-4029-bafe-5aa421bef113",
            name: "Swiss SME Association")
      ];
      //get countries store in localStore
      List<Country> countries = await implUtilityData.getCountries();

      //filter countries
      Country s =
          countries.firstWhere((element) => element.name == "switzerland");
      for (ProfessionalAssociation profAss in swissProfAss) {
        profAss.locationId = s.id;
        bool result = await implUtilityData.storeProfessionAssociation(
            professionalAssociation: profAss);
        expect(result, isTrue);
      }
    });
    test("test getProfessionAssociation when stored", () async {
      List<ProfessionalAssociation> profAss =
          await implUtilityData.getPartnerProfAss();
      expect(profAss, isNotEmpty);
    });
  });

  test("test store public keys", () async {
    bool result = await implUtilityData.storePublicKey();
    expect(result, isTrue);
  });
  test("test get public keys", () async {
    String result = await implUtilityData.getPublicKey;
    print(result);
    expect(result, isNotNull);
  });
}
