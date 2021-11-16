//import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorage {
  //initialize this inside onInit() in your controller
  static Future<StorageController> initLocalStorage() async {
    String dbPath = join(await getDatabasesPath(), 'databaseee.sqlite');
    try {
      StorageController storageController =
          await GenericController('testingUser', SqliteMapper(dbPath));
      return storageController;
    } catch (e) {
      throw Exception("Database Connection: Failed $e");

      // log("Database Connection: Failed \n $e \n $stack");
      // log(dbPath);
      // return null;
    }
  }
}