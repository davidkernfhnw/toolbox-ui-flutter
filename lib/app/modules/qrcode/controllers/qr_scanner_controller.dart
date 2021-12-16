import 'dart:convert';
import 'dart:developer';

import 'package:geiger_toolbox/app/services/cloudReplication/cloud_replication_controller.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/impl_utility_data.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/user_service.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_replication_package/cloud_replication_package.dart';

class QrScannerController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrViewController;

  late ImplUtilityData _utilityData;

  var viewTitle = "".obs;
  final CloudReplicationController _cloudReplicationInstance =
      CloudReplicationController.instance;

  final LocalStorageController localStorageInstance =
      LocalStorageController.instance;
  late final StorageController _storageController;

  //instance
  static QrScannerController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    viewTitle.value = Get.arguments.toString();
    log("Get arguments: ${Get.arguments}");
    _storageController = localStorageInstance.getStorageController;
  }

  void onQRViewCreated(QRViewController controller) {
    log("Qr_Code_Scanner working");
    this.qrViewController = controller;
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      update();
      if (result != null) {
        Map<String, dynamic> json = jsonDecode(result!.code);
        String publicKey = json['publicKey'];
        String senderId = json['userId'];
        String agreement = json['agreement'];
        String currentUserId = await getCurrentUserId();
        bool success = await _cloudReplicationInstance.getReplicationController
            .checkPairing(currentUserId, senderId);
        if (success == false) {
          await _cloudReplicationInstance.getReplicationController
              .setPair(currentUserId, senderId, agreement);
        } else {
          Get.snackbar("error", "You have already paired with this user");
        }
        // _cloudReplicationInstance.getReplicationController
        //     .setPair(userId1, userId2);
      }
    });
  }

  Future<String> getCurrentUserId() async {
    UserService userService = UserService(_storageController);
    String userId = await userService.getUserId;
    return userId;
  }

  Future<void> requestCameraPermission(String page, {dynamic arguments}) async {
    final PermissionStatus cameraStatus = await Permission.camera.request();
    if (cameraStatus == PermissionStatus.granted) {
      log("Permission granted");
      Get.toNamed(page, arguments: arguments);
    } else if (cameraStatus == PermissionStatus.denied) {
      log('Permission denied');
      Get.snackbar("Permission Denied", "Try Again: Please grant Permission.",
          duration: Duration(seconds: 10),
          showProgressIndicator: true,
          snackPosition: SnackPosition.BOTTOM);
    } else if (cameraStatus == PermissionStatus.permanentlyDenied) {
      log('Permission Permanently Denied');
      Get.snackbar("Permission Denied:", "Please press to enable permission.",
          duration: Duration(seconds: 5),
          // backgroundColor: Colors.deepOrangeAccent,
          // colorText: Colors.white,
          onTap: (bar) async {
        await openAppSettings();
      },
          shouldIconPulse: true,
          icon: Icon(Icons.warning_rounded),
          showProgressIndicator: true,
          progressIndicatorBackgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /*void onPermissionSet(QRViewController controller, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      //on other screen, send a data for previous route:
      Get.toNamed(Routes.EMPLOYEE_VIEW, arguments: "Access to Camera:Denied");
    }
  }*/
}
