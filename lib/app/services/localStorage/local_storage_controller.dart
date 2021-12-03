//import 'dart:developer';

import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
import 'package:get/get.dart';
import 'package:geiger_api/geiger_api.dart';

class LocalStorageController extends GetxController {
  //instance of LocalStorageController
  static LocalStorageController to = Get.find<LocalStorageController>();
  //get instance of GeigerApiConnector
  GeigerApiConnector _geigerApiConnector = GeigerApiConnector.to;
  late StorageController _storageController;

  StorageController get getStorageController {
    return _storageController;
  }

  Future<void> initLocalStorage() async {
    try {
      GeigerApi api = await _geigerApiConnector.getGeigerApiMaster;
      _storageController = api.getStorage()!;
    } catch (e) {
      log("Database Connection Error From LocalStorage: $e");
      rethrow;
    }
  }
//Todo
// registered storageListener
//listen to plugin
}
