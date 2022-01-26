import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../../../shared_widgets/indicator_gauge.dart';

class ThreatsCard extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final double? indicatorScore;
  final String? routeName;
  final HomeController? controller;
  final Threat threat;
  const ThreatsCard(
      {Key? key,
      @required this.label,
      @required this.icon,
      @required this.indicatorScore,
      @required this.routeName,
      required this.threat,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              label!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Icon(
              icon,
              color: Colors.black26.withOpacity(0.4),
              size: 110,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IndicatorGauge(
                  score: indicatorScore,
                ),
                ElevatedButton(
                  // onPressed: () async {
                  //   await controller!.cachedUserRecommendation(threat);
                  //   await controller!.cachedDeviceRecommendation(threat);
                  //   Get.toNamed(Routes.RECOMMENDATION_VIEW, arguments: threat);
                  // },
                  onPressed: () => Get.toNamed(Routes.RECOMMENDATION_VIEW,
                      arguments: threat),
                  child: const Text("Improve"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
