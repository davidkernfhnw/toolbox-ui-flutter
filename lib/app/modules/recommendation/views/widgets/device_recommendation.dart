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
        threatTitle: controller.threat.value.threat.name.toString(),
        score: double.parse(controller.threat.value.score.toString()),
        label: 'Current device',
        controller: controller,
        recommendationType: "Device Recommendations",
      ),
    );
  }
}
