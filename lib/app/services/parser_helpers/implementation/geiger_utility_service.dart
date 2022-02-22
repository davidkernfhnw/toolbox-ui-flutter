import 'dart:developer';

import 'package:geiger_localstorage/src/storage_controller.dart';
import 'package:geiger_toolbox/app/model/country.dart';
import 'package:geiger_toolbox/app/model/professional_association.dart';

import '../../../model/cert.dart';
import '../abstract/geiger_utility_abstract.dart';

class GeigerUtilityService extends GeigerUtilityAbstract {
  GeigerUtilityService(StorageController storageController)
      : super(storageController);

  //store list of countries

  Future<void> storeCountry() async {
    // they are store in lowerCase and english
    await storeCountries(countries: [
      Country(name: "Switzerland", id: "cd258b40-4dc1-486a-b000-eb59e71e7484"),
      Country(name: "Netherlands", id: "4b5e6eba-3801-45bd-9485-86378c4b4320"),
      Country(name: "Romania", id: "e60c88f2-7ab7-4e9f-bd26-5d2a062b4af9")
    ]);
    // german
    await storeCountries(countries: [
      Country(name: "Schweiz", id: "cd258b40-4dc1-486a-b000-eb59e71e7484"),
      Country(name: "Niederlande", id: "4b5e6eba-3801-45bd-9485-86378c4b4320"),
      Country(name: "Rumänien", id: "e60c88f2-7ab7-4e9f-bd26-5d2a062b4af9")
    ], language: "de-ch");

    // dutch
    await storeCountries(countries: [
      Country(name: "Zwitserland", id: "cd258b40-4dc1-486a-b000-eb59e71e7484"),
      Country(name: "Nederland", id: "4b5e6eba-3801-45bd-9485-86378c4b4320"),
      Country(name: "Roemenië", id: "e60c88f2-7ab7-4e9f-bd26-5d2a062b4af9")
    ], language: "nl-nl");

    // romanian
    await storeCountries(countries: [
      Country(name: "Elveţia", id: "cd258b40-4dc1-486a-b000-eb59e71e7484"),
      Country(name: "Olanda", id: "4b5e6eba-3801-45bd-9485-86378c4b4320"),
      Country(name: "România", id: "e60c88f2-7ab7-4e9f-bd26-5d2a062b4af9")
    ], language: "ro");
  }

  //store list of CERT base on countries
  //available in the localStorage-
  Future<void> storeCerts() async {
    await _storeSwissCerts();
    //german
    await _storeSwissCertsGerman();
    //dutch
    await _storeSwissCertsDutch();
    //romanian
    await _storeSwissCertsRomanian();
    await _storeNetherLandsCerts();
    await _storeRomaniaCerts();
  }

  //english locale
  Future<void> _storeSwissCerts() async {
    List<Cert> swissCerts = [
      Cert(id: "330e1d39-aad3-43ea-9f32-f89fc82899d9", name: "NCSC Switzerland")
    ];
    //get countries store in localStore
    List<Country> countries = await getCountries();

    //filter countries
    Country s =
        countries.firstWhere((element) => element.name == "switzerland");
    log("Swiss Country => ${s.name}, ${s.id}");
    for (Cert swissCert in swissCerts) {
      swissCert.locationId = s.id;
      await storeCert(cert: swissCert);
    }
  }

  //german locale
  Future<void> _storeSwissCertsGerman() async {
    List<Cert> swissCerts = [
      Cert(id: "330e1d39-aad3-43ea-9f32-f89fc82899d9", name: "NCSC Schweiz")
    ];
    //get countries store in localStore
    List<Country> countries = await getCountries(language: "de-ch");

    //filter countries
    Country s = countries.firstWhere((element) => element.name == "schweiz");
    log("Swiss Country => ${s.name}, ${s.id}");
    for (Cert swissCert in swissCerts) {
      swissCert.locationId = s.id;
      await storeCert(cert: swissCert, language: "de-ch");
    }
  }

  //dutch locale
  Future<void> _storeSwissCertsDutch() async {
    List<Cert> swissCerts = [
      Cert(id: "330e1d39-aad3-43ea-9f32-f89fc82899d9", name: "NCSC zwitserland")
    ];
    //get countries store in localStore
    List<Country> countries = await getCountries(language: "nl-nl");

    //filter countries
    Country s =
        countries.firstWhere((element) => element.name == "zwitserland");
    log("Swiss Country => ${s.name}, ${s.id}");
    for (Cert swissCert in swissCerts) {
      swissCert.locationId = s.id;
      await storeCert(cert: swissCert, language: "nl-nl");
    }
  }

  //romanian locale
  Future<void> _storeSwissCertsRomanian() async {
    List<Cert> swissCerts = [
      Cert(id: "330e1d39-aad3-43ea-9f32-f89fc82899d9", name: "NCSC elveţia")
    ];
    //get countries store in localStore
    List<Country> countries = await getCountries(language: "ro");

    //filter countries
    Country s = countries.firstWhere((element) => element.name == "elveţia");
    log("Swiss Country => ${s.name}, ${s.id}");
    for (Cert swissCert in swissCerts) {
      swissCert.locationId = s.id;
      await storeCert(cert: swissCert, language: "ro");
    }
  }

//Todo store in de-ch, nl-nl and ro
  Future<void> _storeNetherLandsCerts() async {
    List<Cert> netherLandsCerts = [
      Cert(
          id: "ac2b9cd0-d731-43e7-afc2-f354f856e085",
          name: "Digital Trust Centre Netherlands")
    ];
    //get countries store in localStore
    List<Country> countries = await getCountries();

    //filter countries
    Country n =
        countries.firstWhere((element) => element.name == "netherlands");
    for (Cert netherLandsCert in netherLandsCerts) {
      netherLandsCert.locationId = n.id;
      await storeCert(cert: netherLandsCert);
    }
  }

  Future<void> _storeRomaniaCerts() async {
    List<Cert> romaniaCerts = [
      Cert(id: "e60c88f2-7ab7-4e9f-bd26-5d2a062b4af9", name: "CERT Romania")
    ];

    //get countries store in localStore
    List<Country> countries = await getCountries();
    //filter countries
    Country r = countries.firstWhere((element) => element.name == "romania");
    for (Cert romaniaCert in romaniaCerts) {
      romaniaCert.locationId = r.id;
      await storeCert(cert: romaniaCert);
    }
  }

  //store list of professional association base on countries
  //available in the localStorage-
  Future<void> storeProfAss() async {
    await _storeSwissProfAss();
    await _storeNetherlandsProfAss();
    await _storeRomainProfAss();
  }

  Future<void> _storeSwissProfAss() async {
    List<ProfessionalAssociation> swissProfAss = [
      ProfessionalAssociation(
          id: "8d14468b-30c2-414e-95b1-667844529aa3",
          name: "Swiss Yoga Association"),
      ProfessionalAssociation(
          id: "1f850c91-ba00-4691-90c8-9602b24d8815", name: "Coiffure Suisse"),
      ProfessionalAssociation(
          id: "5ea818af-9b8b-4029-bafe-5aa421bef113",
          name: "Swiss SME Association")
    ];
    //get countries store in localStore
    List<Country> countries = await getCountries();

    //filter countries
    Country s =
        countries.firstWhere((element) => element.name == "switzerland");
    for (ProfessionalAssociation profAss in swissProfAss) {
      profAss.locationId = s.id;
      await storeProfessionAssociation(professionalAssociation: profAss);
    }
  }

  Future<void> _storeNetherlandsProfAss() async {
    List<ProfessionalAssociation> netherlandsProfAss = [
      ProfessionalAssociation(
          id: "cf0b8dc8-ee49-4e0a-85a6-42e4c72770ee",
          name: "NetherLands Association")
    ];
    //get countries store in localStore
    List<Country> countries = await getCountries();

    //filter countries
    Country n =
        countries.firstWhere((element) => element.name == "netherlands");
    for (ProfessionalAssociation profAss in netherlandsProfAss) {
      profAss.locationId = n.id;
      await storeProfessionAssociation(professionalAssociation: profAss);
    }
  }

  Future<void> _storeRomainProfAss() async {
    List<ProfessionalAssociation> romaniaProfAss = [
      ProfessionalAssociation(
          id: "25d0930f-f0ba-4a95-a53d-7c402fc6ddea",
          name: "Romania Association")
    ];
    //get countries store in localStore
    List<Country> countries = await getCountries();

    //filter countries
    Country r = countries.firstWhere((element) => element.name == "romania");
    for (ProfessionalAssociation profAss in romaniaProfAss) {
      profAss.locationId = r.id;
      await storeProfessionAssociation(professionalAssociation: profAss);
    }
  }

  //store public key
  Future<void> setPublicKey() async {
    await storePublicKey();
  }
}
