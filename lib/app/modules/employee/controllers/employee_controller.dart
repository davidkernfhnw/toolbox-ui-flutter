import 'dart:developer';

import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:permission_handler/permission_handler.dart';

class EmployeeController extends GetxController {
  // instance of EmployeeController
  static EmployeeController get to => Get.find();

  Future<void> requestCameraPermission() async {
    final PermissionStatus cameraStatus = await Permission.camera.request();
    if (cameraStatus == PermissionStatus.granted) {
      log("Permission granted");
      Get.toNamed(Routes.QrSCANNER_VIEW);
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

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
