import 'package:geiger_toolbox/app/data/model/recommendations_models.dart';
import 'package:get/get.dart';

class RecommendationController extends GetxController {
  List<RecommendationModel> recommendations =
      RecommendationModel.recommendations().obs;
}
