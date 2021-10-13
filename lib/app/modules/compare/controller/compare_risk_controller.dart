import 'dart:developer';

import 'package:get/get.dart';

class CompareRiskController extends GetxController {
  //an instance of CompareRiskController
  static CompareRiskController get to => Get.find();

  final title = 'CompareRisk screen';

  @override
  void onInit() {
    log('>>> compareRiskController init');
    super.onInit();
  }

  @override
  void onReady() {
    log('>>> compareRiskController ready');
    super.onReady();
  }

  @override
  void onClose() {
    log('>>> compareRiskController close');
    super.onClose();
  }
}
