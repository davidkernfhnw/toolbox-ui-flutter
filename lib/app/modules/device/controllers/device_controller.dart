import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/services/cloudReplication/cloud_replication_controller.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/impl_user_service.dart';
import 'package:get/get.dart';

class DeviceController extends GetxController {
  static final DeviceController instance = Get.find<DeviceController>();

  final CloudReplicationController _cloudReplicationInstance =
      CloudReplicationController.instance;

  //getting instance of localStorageController
  final LocalStorageController _localStorage = LocalStorageController.instance;
  //userService
  late final UserService _userService;
  late final StorageController _storageController;

  var devices = [].obs;
  var isUnPairing = false.obs;
  var checkPairResult = "".obs;

  // Future<bool> pair(String data) async {
  //   log("ScanData : $data");
  //   //bool result = await _runPair(data);
  //   if (result == true) {
  //     await _devices();
  //     return true;
  //   } else {
  //     await _devices();
  //     return false;
  //   }
  // }

  // void onPressUnpair({required String userId}) async {
  //   isUnPairing.value = true;
  //   await _unPair(userId);
  //   isUnPairing.value = false;
  // }

  updateUi(String data) {
    checkPairResult.value = data;
  }

  ///return true if pair successfully else false that is already false
  // Future<bool> _runPair(String scanQrCodeData) async {
  //   Map<String, dynamic> json = jsonDecode(scanQrCodeData);
  //   log("decode json: $json");
  //   String publicKey = json['publicKey'];
  //   String senderId = json['userId'];
  //   String agreement = json['agreement'];
  //   String currentUserId = await _getCurrentUserId();
  //   bool previouslyPaired = await _cloudReplicationInstance
  //       .getReplicationController
  //       .checkPairing(currentUserId, senderId);
  //
  //   if (previouslyPaired == false) {
  //     bool pairSuccess = await _cloudReplicationInstance
  //         .getReplicationController
  //         .setPair(currentUserId, senderId, agreement, publicKey);
  //     if (pairSuccess) {
  //       log("pairing success");
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     log("already paired");
  //     return false;
  //   }
  // }

  // Future<bool> _unPair(String userId) async {
  //   bool result = await _runUnpair(userId: userId);
  //   if (result == true) {
  //     await _devices();
  //     return true;
  //   } else {
  //     await _devices();
  //     return false;
  //   }
  // }

  ///return true if unpair successfully else false
  // Future<bool> _runUnpair({required String userId}) async {
  //   bool success = await _cloudReplicationInstance.getReplicationController
  //       .unpair(await _getCurrentUserId(), userId);
  //
  //   if (success == true) {
  //     log("Unpair successfully");
  //     return true;
  //   } else {
  //     log("failed to unpair");
  //     return false;
  //   }
  // }

  Future<void> _devices() async {
    log("getListOfDevices called");
    List<String> r = await _userService.getListPairedDevices();
    devices.value = r;
    log(r.toString());
  }

  Future<String> _getCurrentUserId() async {
    String userId = await _userService.getUserId;
    return userId;
  }

  _checkPairAlert() {
    checkPairResult.isNotEmpty
        ? checkPairResult == "true"
            ? Get.snackbar("Success", "Device Paired Successfully")
            : Get.snackbar("error", "You have already paired with this user",
                backgroundColor: Colors.orangeAccent)
        : log("No new Device added.");
  }

  Future<void> _initialUtilityData() async {
    _storageController = await _localStorage.getStorageController;
    _userService = UserService(_storageController);
  }

  @override
  void onInit() async {
    await _initialUtilityData();
    await _devices();

    _checkPairAlert();
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }
}
