import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/model/recommendation.dart';
import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/indicator_gauge.dart';
import 'package:geiger_toolbox/app/shared_widgets/showCircularProgress.dart';
import 'package:geiger_toolbox/app/util/style.dart';
import 'package:get/get.dart';

import 'expansion_card.dart';

class RecommendationTab extends StatelessWidget {
  final String label;
  final double score;
  final String threatTitle;
  final String? recommendationLabel;
  final String recommendationType;
  final List<Recommendation> recommendations;
  final RecommendationController controller;

  RecommendationTab({
    Key? key,
    required this.recommendations,
    required this.label,
    required this.score,
    required this.threatTitle,
    required this.controller,
    required this.recommendationType,
    this.recommendationLabel,
  }) : super(key: key);
  final GlobalKey expansionTile = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            IndicatorGauge(score: score.toDouble()),
            boldText(label),
            OutlinedButton.icon(
              icon: const Icon(Icons.warning_rounded),
              label: Text("About $threatTitle"),
              onPressed: null,
            ),
            const SizedBox(height: 10),
            recommendations.isEmpty
                ? SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        recommendationLabel ?? "",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      greyText("Risk Reduction"),
                    ],
                  ),
            const SizedBox(
              height: 5,
            ),
            controller.isLoading.value
                ? Center(child: ShowCircularProgress(visible: true))
                : recommendations.isEmpty
                    ? Center(
                        child: Text(
                          "No Recommendation Found",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Column(
                        // animationDuration: Duration(seconds: 2),
                        children:
                            recommendations.map<Widget>((Recommendation r) {
                          return ExpansionCard(
                            recommendation: r,
                            onPressedGetTool: () async {
                              bool result =
                                  await controller.implementRecommendation(
                                recommendation: r,
                              );
                              if (!Get.isSnackbarOpen) {
                                result
                                    ? Get.snackbar("Recommendation!",
                                        "Recommendation successfully Implemented.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.greenAccent)
                                    : Get.snackbar("Recommendation Fails ",
                                        "Consent fail to update.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.orangeAccent);
                              }
                            },
                          );
                        }).toList(),
                      ),
          ],
        ),
      );
    });
  }
}
