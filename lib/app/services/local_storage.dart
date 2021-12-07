//import 'dart:developer';

import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:get/get.dart';
import 'package:geiger_api/geiger_api.dart';

class LocalStorageController extends GetxController {
  //instance
  static LocalStorageController to = Get.find();

  late StorageController storageController;

  // Future<StorageController?> initLocalStorage() async {
  //   try {
  //     GeigerDummy g = GeigerDummy();
  //
  //     GeigerApi api = await g.initGeigerApi();
  //     ;
  //     return api.getStorage();
  //   } catch (e) {
  //     log("Database Connection Error From LocalStorage: $e");
  //     rethrow;
  //   }
  // }
  Future<void> initLocalStorageDummy() async {
    try {
      GeigerDummy g = GeigerDummy();

      GeigerApi api = await g.initGeigerApi();
      storageController = api.getStorage()!;
      //storageController = (await g.getStorageController())!;
    } catch (e) {
      log("Database Connection Error From LocalStorage: $e");
      rethrow;
    }
  }

  Future<GeigerApi> initGeigerApiUi() async {
    flushGeigerApiCache();
    //*****************************************master**********************
    GeigerApi localMaster =
        (await getGeigerApi("", GeigerApi.masterId, Declaration.doShareData))!;
    //clear existing state
    await localMaster.zapState();
    return localMaster;
  }

  Future<StorageController?> initLocalStorageUI() async {
    try {
      GeigerApi api = await initGeigerApiUi();
      storageController = api.getStorage()!;
      //storageController = (await g.getStorageController())!;
    } catch (e) {
      log("Database Connection Error From LocalStorage: $e");
      rethrow;
    }
  }

  @override
  void onInit() async {
    //storageController = (await _initLocalStorage())!;
    super.onInit();
    // await _initLocalStorage();
  }
}
