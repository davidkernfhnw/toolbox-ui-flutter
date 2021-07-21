import 'package:get/get.dart';
import 'package:geiger_toolbox/model/threats_model.dart';

class ScanRiskController extends GetxController {
  List<ThreatsModel> threatList = ThreatsModel.threatList();
}
