//import 'dart:developer';

import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';

import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
import 'package:get/get.dart';
import 'package:geiger_api/geiger_api.dart';

import '../helpers/implementation/impl_utility_data.dart';

class LocalStorageController extends GetxController {
  //instance of LocalStorageController
  static LocalStorageController instance = Get.find<LocalStorageController>();
  //get instance of GeigerApiConnector
  GeigerApiConnector _geigerApiConnector = GeigerApiConnector.instance;

  //private variables
  late StorageController _storageController;
  late GeigerApi _api;
  late ImplUtilityData _utilityData;

  StorageController get getStorageController {
    return _storageController;
  }

  Future<void> _initLocalStorage() async {
    try {
      _api = await _geigerApiConnector.getLocalMaster;
      _storageController = _api.getStorage()!;
    } catch (e) {
      log("Database Connection Error From LocalStorage: $e");
      rethrow;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    await _initLocalStorage();
    super.onInit();
  }

  //close geigerApi after user
  @override
  void onClose() async {
    super.onClose();
    await _api.close();
  }
}

//Todo
// registered storageListener
