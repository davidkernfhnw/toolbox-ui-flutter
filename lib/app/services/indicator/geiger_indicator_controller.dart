import 'dart:developer';

import 'package:get/get.dart';
import 'package:toolbox_indicator_test/indicator.dart';

class GeigerIndicatorController extends GetxController {
  static final GeigerIndicatorController instance = Get.find();

  final String indicatorId = "1234-1234-1234";

  Future<void> initGeigerIndicator() async {
    try {
      log("Run Indicator called");
      await runIndicator(indicatorId);
    } catch (e) {
      log(" Fail to run indicator $e");
    }
  }

  @override
  void onInit() async {
    // await _initGeigerIndicator();
    super.onInit();
  }
}
