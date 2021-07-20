import 'package:get/get.dart';
import 'package:geiger_toolbox/controllers/recommendation_controller.dart';

class RecommendationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecommendationController());
  }
}
