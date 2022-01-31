import 'dart:developer';

import 'package:get/get.dart';
import 'package:initialize_geiger_data/initialize_geiger_data.dart';
import 'package:toolbox_indicator_test/indicator.dart';

class GeigerIndicatorController extends GetxController {
  static final GeigerIndicatorController instance = Get.find();

  final String indicatorId = "1234-1234-1234";

  Future<void> _initGeigerIndicator() async {
    try {
      log("Run Indicator called");
      await await runIndicator(indicatorId);
    } catch (e) {
      log(" Fail to run indicator $e");
    }
  }

  Future<void> _iniGeigerData() async {
    await initializeGeigerData(indicatorId);
  }

  @override
  void onInit() async {
    await _iniGeigerData();
    _initGeigerIndicator();
    super.onInit();
  }
}
