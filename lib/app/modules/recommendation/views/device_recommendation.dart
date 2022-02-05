import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/widgets/recommendation_tab.dart';
import 'package:get/get.dart';

class DeviceRecommendation extends StatelessWidget {
  final RecommendationController controller;
  const DeviceRecommendation({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() {
        return RecommendationTab(
          threatTitle: controller.deviceThreatScore.value.threat.name,
          score: double.parse("${controller.deviceGeigerScore.value}"),
          label: controller.deviceName.value,
          recommendations: controller.deviceGeigerRecommendations,
          recommendationLabel: "Device Recommendations",
          recommendationType: "Device",
          controller: controller,
        );
      }),
    );
  }
}
