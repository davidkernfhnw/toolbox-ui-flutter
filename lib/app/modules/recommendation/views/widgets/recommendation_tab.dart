import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/recommendation.dart';
import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/indicator_gauge.dart';
import 'package:geiger_toolbox/app/util/style.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: [
          IndicatorGauge(score: score.toDouble()),
          boldText(label),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: null,
                child: Row(
                  children: [
                    const Icon(Icons.warning_rounded),
                    const SizedBox(width: 5),
                    Text("About $threatTitle"),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: null,
                child: Row(
                  children: [
                    Icon(Icons.warning_rounded),
                    SizedBox(width: 5),
                    Text("About ${recommendationType}"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          recommendations.isEmpty
              ? SizedBox()
              : Row(
                  children: [
                    Text(
                      recommendationLabel ?? "",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
          const SizedBox(
            height: 5,
          ),
          recommendations.isEmpty
              ? Center(
                  child: Text(
                    "No Recommendation Found",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Column(
                  // animationDuration: Duration(seconds: 2),
                  children: recommendations.map<Widget>((Recommendation r) {
                    return ExpansionCard(
                      recommendation: r,
                      onPressedGetTool: () {
                        controller.implementRecommendation(
                          recommendation: r,
                        );
                      },
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
