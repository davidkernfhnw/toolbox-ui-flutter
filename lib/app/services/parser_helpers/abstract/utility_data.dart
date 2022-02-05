import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/country.dart';
import 'package:geiger_toolbox/app/model/partner.dart';

abstract class UtilityData {
  Future<bool> storeCountries({required List<Country> countries});

  Future<List<Country>> getCountries({String locale: "en"});

  Future<bool> storeProfessionAssociation(
      {required List<Partner> professionAssociation});

  Future<List<Partner>> getProfessionAssociation({String locale: "en"});

  Future<bool> storeCert({required List<Partner> certs});

  Future<List<Partner>> getCert({String locale: "en"});

  Future<Node> getNode(String path, StorageController storageController) async {
    return await storageController.get(path);
  }

  Future<bool> storePublicKey();

  Future<String> get getPublicKey;
}
