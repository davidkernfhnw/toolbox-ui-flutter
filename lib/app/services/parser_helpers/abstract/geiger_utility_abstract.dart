import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/country.dart';
import 'package:geiger_toolbox/app/model/professional_association.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/uuid.dart';
import 'package:intl/src/locale.dart';

import '../../../model/cert.dart';

const String _LOCATION_PATH = ":Global:location";
const String _CERT_PATH = ":Global:cert";
const String _PROF_ASS_PATH = ":Global:professionAssociation";
const String _NODE_OWNER = "geiger-toolbox";

abstract class GeigerUtilityAbstract {
  StorageController storageController;

  GeigerUtilityAbstract(this.storageController);

  Future<List<Cert>> getPartnerCert({String language: "en"}) async {
    List<Cert> certs = await _getCert(language: language);
    return certs;
  }

  Future<List<ProfessionalAssociation>> getPartnerProfAss(
      {String language: "en"}) async {
    List<ProfessionalAssociation> profAss =
        await _getProfessionAssociations(language: language);
    return profAss;
  }

  Future<List<Cert>> _getCert({String language: "en"}) async {
    List<Cert> cert = <Cert>[];
    Node _node;
    try {
      _node = await storageController.get(_CERT_PATH);

      List<String> certIds =
          await _node.getChildNodesCsv().then((value) => value.split(','));
      for (String certId in certIds) {
        Node certNode = (await storageController.get("$_CERT_PATH:${certId}"));
        //print(countryNode);
        NodeValue? certNodeValue = await certNode.getValue("name");
        String certName = certNodeValue!.getValue(language)!;
        NodeValue? certLocId = await certNode.getValue("location");
        String? certLocValueId = certLocId!.value;

        cert.add(Cert(
          id: certId,
          name: certName,
          locationId: certLocValueId,
        ));

        //print("getCountriesNode: $certNode");
      }
      return cert;
    } on StorageException {
      log("List of Cert not in the dataBase");
      return cert;
    }
  }

  Future<List<Country>> getCountries({String language: "en"}) async {
    List<Country> c = <Country>[];
    Node _node;
    try {
      _node = await storageController.get(_LOCATION_PATH);

      List<String> countryIds =
          await _node.getChildNodesCsv().then((value) => value.split(','));
      for (String countryId in countryIds) {
        Node countryNode =
            (await storageController.get("$_LOCATION_PATH:${countryId}"));

        //print(countryNode);
        NodeValue? countryNodeValue = await countryNode.getValue("name");
        String? countryName = countryNodeValue!.getValue(language);
        c.add(Country(id: countryId, name: countryName!));
      }
      return c;
    } on StorageException {
      log("List of Countries not in the dataBase");
      return c;
    }
  }

  Future<List<ProfessionalAssociation>> _getProfessionAssociations(
      {String language: "en"}) async {
    List<ProfessionalAssociation> professionAssociations =
        <ProfessionalAssociation>[];
    Node _node;

    try {
      _node = await storageController.get(_PROF_ASS_PATH);

      List<String> profAssIds =
          await _node.getChildNodesCsv().then((value) => value.split(','));
      for (String profAssId in profAssIds) {
        Node certNode =
            (await storageController.get("$_PROF_ASS_PATH:${profAssId}"));
        //print(countryNode);
        NodeValue? profAssNodeValue = await certNode.getValue("name");
        String profAssName = profAssNodeValue!.getValue(language)!;
        NodeValue? profAssLocId = await certNode.getValue("location");
        String? profAssLocValueId = profAssLocId!.getValue(language);

        professionAssociations.add(ProfessionalAssociation(
            id: profAssId, locationId: profAssLocValueId!, name: profAssName));

        //print("getCountriesNode: $certNode");
      }
      log("PROFESS ASS ==> $professionAssociations");
      return professionAssociations;
    } on StorageException {
      log("List of Cert not in the dataBase");
      return professionAssociations;
    }
  }

  Future<String> get getPublicKey async {
    try {
      NodeValue? nodeValue =
          await storageController.getValue(":Keys", "publicKey");
      String publicKey = nodeValue!.value;
      return publicKey;
    } catch (e, s) {
      throw StorageException("Public Key not found", s);
    }
  }

  Future<bool> storeCert({required Cert cert, String language: "en"}) async {
    Node _n;
    NodeValue? _nodeValueName;
    //create Node path
    Node certNode;
    try {
      certNode = await storageController.get(_CERT_PATH);
    } catch (e) {
      certNode = NodeImpl(_CERT_PATH, _NODE_OWNER);
      await storageController.addOrUpdate(certNode);
    }

    try {
      _n = await storageController.get("$_CERT_PATH:${cert.id}");
      _nodeValueName = await _n.getValue("name");

      _nodeValueName!
          .setValue(cert.name!.toLowerCase(), Locale.parse(language));
      // await _n.addOrUpdateValue(_nV);
      // await storageController.update(_n);

    } on StorageException {
      _n = NodeImpl("$_CERT_PATH:${cert.id}", _NODE_OWNER);
      //_n.visibility = vis.Visibility.white;
      _nodeValueName = NodeValueImpl("name", cert.name!.toLowerCase());
      NodeValue? _nodeValueLocation =
          NodeValueImpl("location", cert.locationId!);
      await _n.addOrUpdateValue(_nodeValueLocation);
    }
    await _n.addOrUpdateValue(_nodeValueName);
    await storageController.addOrUpdate(_n);
    log("CERTS => $_n");

    return true;
  }

  Future<bool> storeCountries(
      {required List<Country> countries, String language: "en"}) async {
    Node _n;
    NodeValue? _nV;
    //create Node path
    Node locationNode;
    try {
      locationNode = await storageController.get(_LOCATION_PATH);
    } catch (e) {
      locationNode = NodeImpl(_LOCATION_PATH, _NODE_OWNER);
      await storageController.addOrUpdate(locationNode);
    }

    for (Country country in countries) {
      try {
        _n = await storageController.get("$_LOCATION_PATH:${country.id}");
        _nV = await _n.getValue("name");

        _nV!.setValue(country.name.toLowerCase(), Locale.parse(language));
        // await _n.addOrUpdateValue(_nV);
        // await storageController.update(_n);

      } on StorageException {
        _n = NodeImpl("$_LOCATION_PATH:${country.id}", _NODE_OWNER);
        //_n.visibility = vis.Visibility.white;
        _nV = NodeValueImpl("name", country.name.toLowerCase());
      }
      await _n.addOrUpdateValue(_nV);
      await storageController.addOrUpdate(_n);
      log("COUNTRIES => $_n");
    }

    return true;
  }

  Future<bool> storeProfessionAssociation(
      {required ProfessionalAssociation professionalAssociation,
      String language: "en"}) async {
    Node _n;
    NodeValue? _nodeValueName;
    //create Node path
    Node certNode;
    try {
      certNode = await storageController.get(_PROF_ASS_PATH);
    } catch (e) {
      certNode = NodeImpl(_PROF_ASS_PATH, _NODE_OWNER);
      await storageController.addOrUpdate(certNode);
    }

    try {
      _n = await storageController
          .get("$_PROF_ASS_PATH:${professionalAssociation.id}");
      _nodeValueName = await _n.getValue("name");

      _nodeValueName!.setValue(
          professionalAssociation.name!.toLowerCase(), Locale.parse(language));
      // await _n.addOrUpdateValue(_nV);
      // await storageController.update(_n);

    } on StorageException {
      _n = NodeImpl(
          "$_PROF_ASS_PATH:${professionalAssociation.id}", _NODE_OWNER);
      //_n.visibility = vis.Visibility.white;
      _nodeValueName =
          NodeValueImpl("name", professionalAssociation.name!.toLowerCase());
      NodeValue? _nodeValueLocation =
          NodeValueImpl("location", professionalAssociation.locationId!);
      await _n.addOrUpdateValue(_nodeValueLocation);
    }
    await _n.addOrUpdateValue(_nodeValueName);
    await storageController.addOrUpdate(_n);
    log("PROF ASSOCIATION => $_n");

    return true;
  }

  Future<bool> storePublicKey() async {
    try {
      Node node = await _getNode(":Keys", storageController);
      String uuid = Uuids.uuid;
      await node.addValue(NodeValueImpl("publicKey", uuid));
      await storageController.addOrUpdate(node);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Node> _getNode(
      String path, StorageController storageController) async {
    return await storageController.get(path);
  }
}

//Todo: refactor storeProfessional, storeCert
