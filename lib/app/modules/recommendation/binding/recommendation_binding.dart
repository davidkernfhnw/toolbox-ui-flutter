import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';
import 'package:get/get.dart';

class RecommendationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecommendationController());
  }
}
