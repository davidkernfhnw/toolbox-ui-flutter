import 'dart:developer';

import 'package:geiger_toolbox/app/services/localStorage/localServices/user_service.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrViewController;

  var viewTitle = "".obs;

  //instance
  static QrScannerController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    viewTitle.value = Get.arguments.toString();
    log("Get arguments: ${Get.arguments}");
  }

  void onQRViewCreated(QRViewController controller) {
    log("Qr_Code_Scanner working");
    this.qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      update();
      if (result != null) {
        Get.snackbar("success", result!.code);
      }
    });
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
