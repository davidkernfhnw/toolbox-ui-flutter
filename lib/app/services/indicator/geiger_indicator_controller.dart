import 'dart:developer';

import 'package:geiger_toolbox/app/services/parser_helpers/implementation/uuid.dart';
import 'package:get/get.dart';
import 'package:toolbox_indicator_test/indicator.dart';

class GeigerIndicatorController extends GetxController {
  static final GeigerIndicatorController instance = Get.find();

  final String indicatorId = Uuids.uuid;

  Future<void> initGeigerIndicator() async {
    try {
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
