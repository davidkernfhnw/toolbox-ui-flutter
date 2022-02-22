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
      await implUtilityData.storeCountries(countries: [
        Country(id: "1", name: "switzerland"),
        Country(id: "2", name: "netherlands"),
        Country(id: "3", name: "romania")
      ]);
    });

    test("test getCountries when stored", () async {
      List<Country> c = await implUtilityData.getCountries();
      expect(c, isNotEmpty);
    });

    test("test storeCountries in de-ch locale", () async {
      bool r = await implUtilityData.storeCountries(countries: [
        Country(id: "1", name: "switzerland in german"),
        Country(id: "2", name: "netherlands in german "),
        Country(id: "3", name: "romania in german")
      ], language: "de-ch");
      expect(r, isTrue);
    });

    test("test storeCountries in nl-nl locale", () async {
      bool r = await implUtilityData.storeCountries(countries: [
        Country(id: "1", name: "switzerland in dutch"),
        Country(id: "2", name: "netherlands in dutch "),
        Country(id: "3", name: "romania in dutch")
      ], language: "nl-nl");
      expect(r, isTrue);
    });
    test("test storeCountries in ro locale", () async {
      bool r = await implUtilityData.storeCountries(countries: [
        Country(id: "1", name: "switzerland in romania "),
        Country(id: "2", name: "netherlands in romania "),
        Country(id: "3", name: "romania in romania ")
      ], language: "ro");
      expect(r, isTrue);
    });
    test("test getCountries when stored without locale", () async {
      List<Country> c = await implUtilityData.getCountries();
      print("default(en) ==> $c");
      expect(c, isNotEmpty);
    });

    test("test getCountries when stored in multiple locale", () async {
      List<Country> deCh =
          await implUtilityData.getCountries(language: "de-ch");
      List<Country> nlNl =
          await implUtilityData.getCountries(language: "nl-nl");
      List<Country> ro = await implUtilityData.getCountries(language: "ro");
      print("dech ==> $deCh");
      print("dutch ===> $nlNl");
      print("romania ==> $ro");
    });

    test("test first country name with locale", () async {
      List<Country> c = await implUtilityData.getCountries(language: "de-ch");
      print(c.first.name);
      expect(c, isNotEmpty);
    });

    test("test first country name without locale", () async {
      List<Country> c = await implUtilityData.getCountries();
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

    test("test storeCert with locale", () async {
      List<Cert> swissCerts = [
        Cert(
            id: "330e1d39-aad3-43ea-9f32-f89fc82899d9",
            name: "NCSC Switzerland german locale")
      ];
      //get countries store in localStore
      List<Country> countries =
          await implUtilityData.getCountries(language: "de-ch");

      //filter countries
      Country s = countries
          .firstWhere((element) => element.name == "switzerland in german");
      for (Cert swissCert in swissCerts) {
        swissCert.locationId = s.id;
        bool result =
            await implUtilityData.storeCert(cert: swissCert, language: "de-ch");
        print("************");
        print("$result");
        expect(result, isTrue);
      }
    });

    test("test getCert without locale", () async {
      print("********");
      List<Cert> certs = await implUtilityData.getPartnerCert();
      print(certs);
      expect(
        certs,
        isNotEmpty,
      );
    });
    test("test getCert with locale", () async {
      print("********");
      List<Cert> certs =
          await implUtilityData.getPartnerCert(language: "de-ch");
      print(certs);
      expect(
        certs,
        isNotEmpty,
      );
    });

    test("test getProfessionAssociation when not stored", () async {
      print("********");
      List<ProfessionalAssociation> profAss =
          await implUtilityData.getPartnerProfAss();
      expect(profAss, isEmpty);
    });

    test("test storeProfessionAssociation without locale", () async {
      print("test storeProfessionAssociation without locale");
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
      print(" countries ==> $countries");
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
    test("test storeProfessionAssociation with locale", () async {
      print("test storeProfessionAssociation with locale");
      List<ProfessionalAssociation> swissProfAss = [
        ProfessionalAssociation(
            id: "8d14468b-30c2-414e-95b1-667844529aa3",
            name: "Swiss Yoga Association in german"),
        ProfessionalAssociation(
            id: "1f850c91-ba00-4691-90c8-9602b24d8815",
            name: "Coiffure Suisse in german"),
        ProfessionalAssociation(
            id: "5ea818af-9b8b-4029-bafe-5aa421bef113",
            name: "Swiss SME Association in german")
      ];
      //get countries store in localStore
      List<Country> countries =
          await implUtilityData.getCountries(language: "de-ch");
      print("locale countries ==> $countries");
      //filter countries
      Country s = countries
          .firstWhere((element) => element.name == "switzerland in german");
      for (ProfessionalAssociation profAss in swissProfAss) {
        profAss.locationId = s.id;
        bool result = await implUtilityData.storeProfessionAssociation(
            professionalAssociation: profAss, language: "de-ch");

        expect(result, isTrue);
      }
    });

    test("test getProfessionAssociation when stored without locale", () async {
      print("test getProfessionAssociation when stored without locale");
      List<ProfessionalAssociation> profAss =
          await implUtilityData.getPartnerProfAss();
      print(profAss);
      expect(profAss, isNotEmpty);
    });
  });

  test("test getProfessionAssociation when stored with locale", () async {
    print("test getProfessionAssociation when stored with locale");
    List<ProfessionalAssociation> profAss =
        await implUtilityData.getPartnerProfAss(language: "de-ch");
    print(profAss);
    expect(profAss, isNotEmpty);
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
