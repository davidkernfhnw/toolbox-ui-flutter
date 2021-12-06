import 'dart:developer';

import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';
import 'package:geiger_toolbox/app/services/localStorage/abstract/utility_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/src/locale.dart';
import 'package:geiger_localstorage/src/visibility.dart' as vis;

const String _PATH = ":Global:location";
// const String _DEVICE_KEY = "deviceInfo";
const String _NODE_OWNER = "geiger";

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
      _node = await storageController.get(_PATH);

      List<String> countryIds =
          await _node.getChildNodesCsv().then((value) => value.split(','));
      for (String countryId in countryIds) {
        Node countryNode = (await storageController.get("$_PATH:${countryId}"));
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
  Future<List<Partner>> getProfessionAssociation({String locale: "en"}) {
    // TODO: implement getProfessionAssociation
    throw UnimplementedError();
  }

  @override
  Future<bool> storeCert({Locale? language, required List<Partner> cert}) {
    // TODO: implement storeCert
    throw UnimplementedError();
  }

  @override
  Future<bool> storeCountries(
      {Locale? locale, required List<Country> countries}) async {
    try {
      for (Country country in countries) {
        _node = await storageController.get("$_PATH:${country.id}");
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
        _node = NodeImpl(_PATH, _NODE_OWNER);
        //create location sub node
        await storageController.addOrUpdate(_node);

        for (Country country in countries) {
          Node idNode = NodeImpl("$_PATH:${country.id}", _NODE_OWNER);
          idNode.visibility = vis.Visibility.white;
          await storageController.addOrUpdate(idNode);
          NodeValue countryName = NodeValueImpl("name", country.name);
          if (locale != null) {
            countryName.setValue(country.name, locale);
          }

          await idNode.addOrUpdateValue(countryName);
          await storageController.update(idNode);
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
