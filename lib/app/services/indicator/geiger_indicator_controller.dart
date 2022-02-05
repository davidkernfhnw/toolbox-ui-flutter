import 'dart:developer';

import 'package:get/get.dart';
import 'package:initialize_geiger_data/initialize_geiger_data.dart';
import 'package:toolbox_indicator_test/indicator.dart';

class GeigerIndicatorController extends GetxController {
  static final GeigerIndicatorController instance = Get.find();

  final String indicatorId = "1234-1234-1234";

  Future<void> initGeigerIndicator() async {
    try {
      log("Run Indicator called");
      await await runIndicator(indicatorId);
    } catch (e) {
      log(" Fail to run indicator $e");
    }
  }

  Future<void> _iniGeigerData() async {
    log("IniGeigerData called");
    try {
      await initializeGeigerData(indicatorId);
    } catch (e) {
      log("Initialized GeigerData Already...\n");
    }
  }

  @override
  void onInit() async {
    _iniGeigerData();
    super.onInit();
  }
}
