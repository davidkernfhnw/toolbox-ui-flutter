import 'package:get/get.dart';
import 'package:geiger_toolbox/model/recommendations.dart';

class RecommendationController extends GetxController {
  List<RecommendationModel> recommendations =
      RecommendationModel.recommendations();

  void isExpanding(int i, bool isOpen) {
    recommendations[i].isExpanded = !isOpen;
  }
}
