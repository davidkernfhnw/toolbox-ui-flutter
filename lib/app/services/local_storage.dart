import 'dart:developer';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorage {
  //initialize this inside onInit() in your controller
  static Future<StorageController?> initLocalStorage() async {
    String dbPath = join(await getDatabasesPath(), 'test4212.sqlite');
    try {
      StorageController storageController =
          GenericController('test123', SqliteMapper(dbPath));
      return storageController;
    } catch (e, stack) {
      //throw Exception("Database Connection: Failed");

      log("Database Connection: Failed \n $e \n $stack");
      log(dbPath);
      return null;
    }
  }
}
