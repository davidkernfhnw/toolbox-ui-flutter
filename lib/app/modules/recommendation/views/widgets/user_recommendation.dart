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
          threatTitle: controller.threat.value.name.toString(),
          score: double.parse(controller.threat.value.score!.score ?? "44.3"),
          label: 'Current user',
          controller: controller,
          recommendationType: "Personal Recommendations",
        );
      }),
    );
  }
}
