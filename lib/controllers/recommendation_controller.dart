import 'package:get/get.dart';
import 'package:geiger_toolbox/model/recommendations_models.dart';

class RecommendationController extends GetxController {
  List<RecommendationModel> recommendations =
      RecommendationModel.recommendations().obs;

  var press = false.obs;

  void isExpanding(int i, bool isOpen) {
    recommendations[i].isExpanded = !isOpen;
    press.value = recommendations[i].isExpanded;
  }
}
