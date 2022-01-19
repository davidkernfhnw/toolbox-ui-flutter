import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/device/controllers/device_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerController extends GetxController {
  //instance
  static QrScannerController get instance => Get.find();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrViewController;

  //final DeviceController deviceControllerInstance = DeviceController.instance;
  //Todo refactor
  final DeviceController deviceControllerInstance = Get.put(DeviceController());
  var viewTitle = "".obs;
  var scanQrCodeData = "".obs;
  var isScanning = false.obs;

  void onQRViewCreated(QRViewController controller) {
    log("Qr_Code_Scanner working");
    this.qrViewController = controller;
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      scanQrCodeData.value = scanData.code;
      //await controller.resumeCamera();
    });

    //on scanQrCodeData value, navigate to either
    // and call the pair method
    // the device screen or employee screen
    once(scanQrCodeData, (_) async {
      log(scanQrCodeData.value);
      if (viewTitle.value != "Add an employee") {
        isScanning.value = true;
        bool result = await deviceControllerInstance.pair(scanQrCodeData.value);
        isScanning.value = false;
        controller.dispose();
        await Get.delete<DeviceController>();
        Get.put<DeviceController>(DeviceController());
        Get.find<DeviceController>().updateUi(result.toString());
        return Get.back();
      } else {
        //Todo: pair of users
        return await Get.offNamed(Routes.EMPLOYEE_VIEW);
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
      if (!Get.isSnackbarOpen) {
        Get.snackbar("Permission Denied", "Try Again: Please grant Permission.",
            showProgressIndicator: true, snackPosition: SnackPosition.BOTTOM);
      }
    } else if (cameraStatus == PermissionStatus.permanentlyDenied) {
      log('Permission Permanently Denied');
      if (!Get.isSnackbarOpen) {
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
  }

  @override
  void onInit() {
    super.onInit();
    viewTitle.value = Get.arguments.toString();
    log("Get arguments: ${Get.arguments}");
  }

  @override
  void onClose() {
    qrViewController!.dispose();
    super.onClose();
  }
}

//Todo: check for internet connection before replication/pairing/unpair
