import 'package:flutter/material.dart';

import 'package:geiger_toolbox/app/modules/recommendation/views/widgets/recommendation_tab.dart';

import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';

class DeviceRecommendation extends StatelessWidget {
  final RecommendationController controller;
  const DeviceRecommendation({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RecommendationTab(
        threatTitle: controller.deviceThreatScore.value.threat.name,
        score: double.parse("${controller.deviceGeigerScore.value}.0"),
        label: 'Current device',
        recommendations:
            controller.deviceGeigerRecommendations.value.recommendations,
        recommendationType: "Device Recommendations",
      ),
    );
  }
}
