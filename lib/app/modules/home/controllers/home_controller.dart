import 'package:geiger_toolbox/app/data/model/threats_model.dart';

import 'package:get/get.dart';

class HomeController extends GetxController {
  List<ThreatsModel> threatList = ThreatsModel.threatList();
}
