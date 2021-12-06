import 'dart:developer';

import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';
import 'package:geiger_toolbox/app/services/localStorage/abstract/utility_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/src/locale.dart';
import 'package:geiger_localstorage/src/visibility.dart' as vis;

const String _LOCATION_PATH = ":Global:location";
const String _CERT_PATH = ":Global:cert";
const String _NODE_OWNER = "geigerUi";

class ImplUtilityData extends UtilityData {
  //final LocalStorageController _localStorage = LocalStorageController.instance;
  late Node _node;
  late NodeValue _nodeValue;

  StorageController storageController;

  ImplUtilityData(this.storageController);
  @override
  Future<List<Partner>> getCert({String locale: "en"}) {
    // TODO: implement getCert
    throw UnimplementedError();
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

        print("getCountriesNode: $countryNode");
      }
      return c;
    } on StorageException {
      log("List of Countries not in the dataBase");
      return c;
    }
  }

  @override
  Future<List<Partner>> getProfessionAssociation({String locale: "en"}) {
    // TODO: implement getProfessionAssociation
    throw UnimplementedError();
  }

  @override
  Future<bool> storeCert({Locale? locale, required List<Partner> certs}) async {
    try {
      for (Partner cert in certs) {
        _node = await storageController.get("$_CERT_PATH:${cert.id}");
        //store cert names as csv
        _nodeValue = NodeValueImpl("names", cert.names.join(","));
        //store location id
        NodeValue _nodeLocation = NodeValueImpl("location", cert.location.id!);
        NodeValue _nodeLocationName =
            NodeValueImpl("locationName", cert.location.name);
        if (locale != null) {
          _nodeValue.setValue(cert.names.join(","), locale);
        }
        //await _node.addOrUpdateValue(_nodeValue);
        await _node.addOrUpdateValue(_nodeLocation);
        await _node.addOrUpdateValue(_nodeLocationName);
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
          if (locale != null) {
            certName.setValue(cert.names.join(","), locale);
            _nodeLocation.setValue(cert.location.id!, locale);
            _nodeLocationName.setValue(cert.location.name, locale);
          }

          await idNode.addOrUpdateValue(certName);
          await idNode.addOrUpdateValue(_nodeLocation);
          await idNode.addOrUpdateValue(_nodeLocationName);
          await storageController.update(idNode);
          print(idNode);
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
  Future<bool> storeCountries(
      {Locale? locale, required List<Country> countries}) async {
    try {
      for (Country country in countries) {
        _node = await storageController.get("$_LOCATION_PATH:${country.id}");
        _nodeValue = NodeValueImpl("name", country.name);
        if (locale != null) {
          _nodeValue.setValue(country.name, locale);
        }
        await _node.addOrUpdateValue(_nodeValue);
        await storageController.update(_node);
      }
      return true;
    } on StorageException {
      try {
        Node _node = NodeImpl(_LOCATION_PATH, _NODE_OWNER);
        //create location sub node
        await storageController.addOrUpdate(_node);
        Node idNode;
        for (Country country in countries) {
          idNode = NodeImpl("$_LOCATION_PATH:${country.id}", _NODE_OWNER);
          idNode.visibility = vis.Visibility.white;
          await storageController.addOrUpdate(idNode);
          NodeValue countryName = NodeValueImpl("name", country.name);
          if (locale != null) {
            countryName.setValue(country.name, locale);
          }

          await idNode.addOrUpdateValue(countryName);
          await storageController.update(idNode);
          //print(idNode);
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
  Future<bool> storeProfessionAssociation(
      {Locale? locale, required List<Partner> profAss}) {
    // TODO: implement storeProfessionAssociation
    throw UnimplementedError();
  }
}
