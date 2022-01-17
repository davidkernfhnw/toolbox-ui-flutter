// import 'dart:developer';
//
// import 'package:geiger_dummy_data/geiger_dummy_data.dart';
// import 'package:get/get.dart';
//
// class DummyStorageController extends GetxController {
//   //instance
//   static final DummyStorageController instance =
//       Get.find<DummyStorageController>();
//   late final GeigerDummy _geigerDummy;
//
//   GeigerDummy get getDummyController {
//     return _geigerDummy;
//   }
//
//   void _initialGeigerDummy() {
//     _geigerDummy = GeigerDummy();
//   }
//
//   Future<void> initLocalStorageDummy() async {
//     log("initLocalStorageDummy method has been called");
//     try {
//       await _geigerDummy.initDummyDataStorage();
//       log("dummy Data storage initialized");
//     } catch (e) {
//       log("Database Connection Error From LocalStorage Dummy: $e");
//       rethrow;
//     }
//   }
//
//   Future<void> setDummyData() async {
//     await _geigerDummy.initialGeigerDummyData();
//   }
//
//   Future<void> storeRecom() async {
//     await _geigerDummy.storeData();
//   }
//
//   @override
//   void onInit() async {
//     _initialGeigerDummy();
//     super.onInit();
//   }
// }
