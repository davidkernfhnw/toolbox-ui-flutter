import 'package:get/get.dart';
import 'package:geiger_toolbox/model/recommendations_models.dart';

class RecommendationController extends GetxController {
  List<RecommendationModel> recommendations =
      RecommendationModel.recommendations().obs;
}
