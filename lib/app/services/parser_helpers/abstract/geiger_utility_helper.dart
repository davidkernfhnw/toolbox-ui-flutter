import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_localstorage/src/visibility.dart' as vis;
import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/uuid.dart';
import 'package:intl/src/locale.dart';

import 'utility_data.dart';

const String _LOCATION_PATH = ":Global:location";
const String _CERT_PATH = ":Global:cert";
const String _PROF_ASS_PATH = ":Global:professionAssociation";
const String _NODE_OWNER = "geiger-toolbox";

abstract class GeigerUtilityHelper extends UtilityData {
  //final LocalStorageController _localStorage = LocalStorageController.instance;
  late Node _node;
  late NodeValue _nodeValue;

  StorageController storageController;

  GeigerUtilityHelper(this.storageController);
  @override
  Future<List<Partner>> getCert({String locale: "en"}) async {
    List<Partner> cert = <Partner>[];
    try {
      _node = await storageController.get(_CERT_PATH);

      List<String> certIds =
          await _node.getChildNodesCsv().then((value) => value.split(','));
      for (String certId in certIds) {
        Node certNode = (await storageController.get("$_CERT_PATH:${certId}"));
        //print(countryNode);
        NodeValue? certNodeValue = await certNode.getValue("names");
        List<String> certNames = certNodeValue!.getValue(locale)!.split(',');
        NodeValue? certLocId = await certNode.getValue("location");
        String? certLocValueId = certLocId!.getValue(locale);
        NodeValue? certLocName = await certNode.getValue("locationName");
        String? certLocValueName = certLocName!.getValue(locale);

        cert.add(Partner(
            id: certId,
            location: Country(id: certLocValueId, name: certLocValueName!),
            names: certNames));

        //print("getCountriesNode: $certNode");
      }
      return cert;
    } on StorageException {
      log("List of Cert not in the dataBase");
      return cert;
    }
  }

  @override
  Future<List<Country>> getCountries({String locale: "en"}) async {
    List<Country> c = <Country>[];
    try {
      _node = await storageController.get(_LOCATION_PATH);

      List<String> countryIds =
          await _node.getChildNodesCsv().then((value) => value.split(','));
      for (String countryId in countryIds) {
        Node countryNode =
            (await storageController.get("$_LOCATION_PATH:${countryId}"));

        //print(countryNode);
        NodeValue? countryNodeValue = await countryNode.getValue("name");
        String? countryName = countryNodeValue!.getValue(locale);
        c.add(Country(id: countryId, name: countryName!));
      }
      return c;
    } on StorageException {
      log("List of Countries not in the dataBase");
      return c;
    }
  }

  @override
  Future<List<Partner>> getProfessionAssociation({String locale: "en"}) async {
    List<Partner> professionAssociation = <Partner>[];

    try {
      _node = await storageController.get(_PROF_ASS_PATH);

      List<String> profAssIds =
          await _node.getChildNodesCsv().then((value) => value.split(','));
      for (String profAssId in profAssIds) {
        Node certNode =
            (await storageController.get("$_PROF_ASS_PATH:${profAssId}"));
        //print(countryNode);
        NodeValue? profAssNodeValue = await certNode.getValue("names");
        List<String> profAssNames =
            profAssNodeValue!.getValue(locale)!.split(',');
        NodeValue? profAssLocId = await certNode.getValue("location");
        String? profAssLocValueId = profAssLocId!.getValue(locale);
        NodeValue? profAssLocName = await certNode.getValue("locationName");
        String? certLocValueName = profAssLocName!.getValue(locale);

        professionAssociation.add(Partner(
            id: profAssId,
            location: Country(id: profAssLocValueId, name: certLocValueName!),
            names: profAssNames));

        //print("getCountriesNode: $certNode");
      }
      return professionAssociation;
    } on StorageException {
      log("List of Cert not in the dataBase");
      return professionAssociation;
    }
  }

  @override
  Future<bool> storeCert({required List<Partner> certs}) async {
    try {
      for (Partner cert in certs) {
        _node = await storageController.get("$_CERT_PATH:${cert.id}");
        //store cert names as csv
        _nodeValue = NodeValueImpl("names", cert.names.join(","));
        //store location id
        NodeValue _nodeLocation = NodeValueImpl("location", cert.location.id!);
        NodeValue _nodeLocationName =
            NodeValueImpl("locationName", cert.location.name);

        _nodeValue.setValue(cert.names.join(","), Locale.parse(cert.locale));

        //await _node.addOrUpdateValue(_nodeValue);
        await _node.updateValue(_nodeLocation);
        await _node.updateValue(_nodeLocationName);
        await storageController.update(_node);
      }
      return true;
    } on StorageException {
      try {
        Node _node = NodeImpl(_CERT_PATH, _NODE_OWNER);
        //create location sub node
        await storageController.addOrUpdate(_node);
        for (Partner cert in certs) {
          Node idNode = NodeImpl("$_CERT_PATH:${cert.id}", _NODE_OWNER);
          idNode.visibility = vis.Visibility.white;
          await storageController.addOrUpdate(idNode);
          NodeValue certName = NodeValueImpl("names", cert.names.join(","));
          //store location id
          NodeValue _nodeLocation =
              NodeValueImpl("location", cert.location.id!);
          NodeValue _nodeLocationName =
              NodeValueImpl("locationName", cert.location.name);

          //translation

          certName.setValue(cert.names.join(","), Locale.parse(cert.locale));
          _nodeLocation.setValue(cert.location.id!, Locale.parse(cert.locale));
          _nodeLocationName.setValue(
              cert.location.name, Locale.parse(cert.locale));

          await idNode.addOrUpdateValue(certName);
          await idNode.addOrUpdateValue(_nodeLocation);
          await idNode.addOrUpdateValue(_nodeLocationName);
          await storageController.update(idNode);
          log(idNode.toString());
        }
        return true;
      } catch (e) {
        //should never happen:
        log(e.toString());
        return false;
      }
    }
  }

  @override
  Future<bool> storeCountries({required List<Country> countries}) async {
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

        _nV!.setValue(country.name.toLowerCase(), Locale.parse(country.locale));
        // await _n.addOrUpdateValue(_nV);
        // await storageController.update(_n);

      } on StorageException {
        _n = NodeImpl("$_LOCATION_PATH:${country.id}", _NODE_OWNER);
        //_n.visibility = vis.Visibility.white;
        _nV = NodeValueImpl("name", country.name.toLowerCase());
      }
      await _n.addOrUpdateValue(_nV);
      await storageController.addOrUpdate(_n);
    }

    return true;
  }

  @override
  Future<bool> storeProfessionAssociation(
      {required List<Partner> professionAssociation}) async {
    try {
      for (Partner profAss in professionAssociation) {
        _node = await storageController.get("$_PROF_ASS_PATH:${profAss.id}");
        //store profAss names as csv
        _nodeValue = NodeValueImpl("names", profAss.names.join(","));
        //store location id
        NodeValue _nodeLocation =
            NodeValueImpl("location", profAss.location.id!);
        NodeValue _nodeLocationName =
            NodeValueImpl("locationName", profAss.location.name);

        _nodeValue.setValue(
            profAss.names.join(","), Locale.parse(profAss.locale));
        _nodeLocation.setValue(
            profAss.location.id!, Locale.parse(profAss.locale));
        _nodeLocationName.setValue(
            profAss.location.name, Locale.parse(profAss.locale));

        await _node.updateValue(_nodeValue);
        await _node.updateValue(_nodeLocation);
        await _node.updateValue(_nodeLocationName);
        await storageController.update(_node);
      }
      return true;
    } on StorageException {
      try {
        Node _node = NodeImpl(_PROF_ASS_PATH, _NODE_OWNER);
        //create location sub node
        await storageController.addOrUpdate(_node);
        for (Partner profAss in professionAssociation) {
          Node idNode = NodeImpl("$_PROF_ASS_PATH:${profAss.id}", _NODE_OWNER);
          idNode.visibility = vis.Visibility.white;
          await storageController.addOrUpdate(idNode);
          NodeValue certName = NodeValueImpl("names", profAss.names.join(","));
          //store location id
          NodeValue _nodeLocation =
              NodeValueImpl("location", profAss.location.id!);
          NodeValue _nodeLocationName =
              NodeValueImpl("locationName", profAss.location.name);

          //translation

          certName.setValue(
              profAss.names.join(","), Locale.parse(profAss.locale));
          _nodeLocation.setValue(
              profAss.location.id!, Locale.parse(profAss.locale));
          _nodeLocationName.setValue(
              profAss.location.name, Locale.parse(profAss.locale));

          await idNode.addOrUpdateValue(certName);
          await idNode.addOrUpdateValue(_nodeLocation);
          await idNode.addOrUpdateValue(_nodeLocationName);
          await storageController.update(idNode);
          log(idNode.toString());
        }
        return true;
      } catch (e) {
        //should never happen:
        log(e.toString());
        return false;
      }
    }
  }

  @override
  Future<bool> storePublicKey() async {
    try {
      Node node = await getNode(":Keys", storageController);
      String uuid = Uuids.uuid;
      await node.addValue(NodeValueImpl("publicKey", uuid));
      await storageController.addOrUpdate(node);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
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
}

//Todo: refactor storeProfessional, storeCert
