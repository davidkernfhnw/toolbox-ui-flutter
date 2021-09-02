import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/recommendations_models.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/widgets/recommendation_tab.dart';
import 'package:geiger_toolbox/app/shared_widgets/indicator_guage.dart';
import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';

import 'package:get/get.dart';

import 'expansion_card.dart';

class UserRecommendation extends StatelessWidget {
  final RecommendationController controller;
  const UserRecommendation({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RecommendationTab(
        threatTitle: Get.parameters['threatTitle'].toString(),
        score: 44,
        label: 'Current user',
        controller: controller,
        recommendationType: "Personal Recommendations",
      ),
    );
  }
}