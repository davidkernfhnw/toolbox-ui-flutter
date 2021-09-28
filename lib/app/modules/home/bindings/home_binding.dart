import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    //only called when someone use Get.find<HomeController>()
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}
