//import 'dart:developer';

import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

class LocalStorage {
  //initialize this inside onInit() in your controller
  static Future<StorageController?> initLocalStorage() async {
    // String dbPath =
    //     join(await getDatabasesPath(), 'samuelawaffwawafawfw123awir45.sqlite');
    try {
      // StorageController storageController =
      //     await GenericController('testingUser', SqliteMapper(dbPath));
      GeigerDummy geigerDummy = GeigerDummy();
      return await geigerDummy.localGeigerApi();
    } catch (e) {
      log("Database Connection Error From LocalStorage: $e");
      rethrow;
      // log("Database Connection: Failed \n $e \n $stack");
      // log(dbPath);
      // return null;
    }
  }
}
