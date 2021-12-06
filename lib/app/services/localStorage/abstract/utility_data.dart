import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/data/model/partner.dart';
import 'package:uuid/uuid.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:intl/locale.dart';

abstract class UtilityData {
  Future<bool> storeCountries(
      {Locale? locale, required List<Country> countries});

  Future<List<Map>> getCountries({Locale? language});

  Future<bool> storeProfessionAssociation(
      {Locale? locale, required List<Partner> profAss});

  Future<List<Partner>> getProfessionAssociation({Locale? language});

  Future<bool> storeCert({Locale? language, required List<Partner> cert});

  Future<List<Partner>> getCert({Locale? language});

  // ----- Helpers

  static String get uuid {
    ///Generate a v4 (random) id
    return Uuid().v4();
  }

  Future<Node> getNode(String path, StorageController storageController) async {
    return await storageController.get(path);
  }
}
