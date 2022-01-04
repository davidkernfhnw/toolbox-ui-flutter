import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/widgets/recommendation_tab.dart';
import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';

import 'package:get/get.dart';

class UserRecommendation extends StatelessWidget {
  final RecommendationController controller;
  const UserRecommendation({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() {
        return RecommendationTab(
          threatTitle: controller.userThreatScore.value.threat.name,
          score: double.parse("${controller.userGeigerScore.value}.0"),
          label: 'Current user',
          recommendations:
              controller.userGeigerRecommendations.value.recommendations,
          recommendationType: "Personal Recommendations",
        );
      }),
    );
  }
}
