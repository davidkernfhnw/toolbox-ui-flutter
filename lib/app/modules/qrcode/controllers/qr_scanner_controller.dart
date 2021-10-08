import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrViewController;

  //instance
  static QrScannerController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  void onQRViewCreated(QRViewController controller) {
    log("Qr_Code_Scanner working");
    this.qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      update();
    });
  }

  /*void onPermissionSet(QRViewController controller, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      //on other screen, send a data for previous route:
      Get.toNamed(Routes.EMPLOYEE_VIEW, arguments: "Access to Camera:Denied");
    }
  }*/
}
