
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetConnectionController extends GetxController {
  static final InternetConnectionController instance = Get.find<InternetConnectionController>();

   _showSnackbar() {
    return
      Get.snackbar(
        "No internet connection",
        "Connection to the internet could not be established. Please connect to Wifi or Mobile Network.",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.black  );
  }

  Future<bool> isInternetConnected() async {
    try {
      await InternetAddress.lookup('www.google.com');
      return true;
    } on SocketException catch (_) {
        _showSnackbar();
       log("Connection to the internet could not be established");
        return false;


    }

  }

}