import 'package:geiger_toolbox/app/data/model/threats_model.dart';

import 'package:get/get.dart';

class HomeController extends GetxController {
  //an instance of HomeController
  static HomeController get to => Get.find();
  List<ThreatsModel> threatList = ThreatsModel.threatList();
}
