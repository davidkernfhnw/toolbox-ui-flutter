import 'package:get/get.dart';

class CompareRiskController extends GetxController {
  //an instance of CompareRiskController
  static CompareRiskController get to => Get.find();

  final title = 'CompareRisk screen';

  @override
  void onInit() {
    print('>>> compareRiskController init');
    super.onInit();
  }

  @override
  void onReady() {
    print('>>> compareRiskController ready');
    super.onReady();
  }

  @override
  void onClose() {
    print('>>> compareRiskController close');
    super.onClose();
  }
}
