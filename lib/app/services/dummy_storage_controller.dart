import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:get/get.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

class DummyStorageController extends GetxController {
  //instance
  static final DummyStorageController instance =
      Get.find<DummyStorageController>();
  late final StorageController _controller;

  StorageController get getDummyController {
    return _controller;
  }

  Future<void> initLocalStorageDummy() async {
    log("initLocalStorageDummy method has been called");
    try {
      GeigerDummy g = GeigerDummy();
      //initial dummy data
      _controller = await g.initDummyDataStorage();
      log("got $_controller");
      log("dummy Data storage initialized");
    } catch (e) {
      log("Database Connection Error From LocalStorage Dummy: $e");
      rethrow;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    //await _initLocalStorageDummy();
  }
}
