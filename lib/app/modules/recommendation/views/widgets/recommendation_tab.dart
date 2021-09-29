import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/recommendations_models.dart';
import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/indicator_gauge.dart';
import 'package:get/get.dart';
import 'expansion_card.dart';

class RecommendationTab extends StatelessWidget {
  final String label;
  final double score;
  final String threatTitle;
  final String? recommendationType;
  final RecommendationController controller;

  const RecommendationTab({
    Key? key,
    required this.controller,
    required this.label,
    required this.score,
    required this.threatTitle,
    this.recommendationType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: [
          IndicatorGauge(score: score.toDouble()),
          Text(label),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: null,
                child: Row(
                  children: [
                    Icon(Icons.warning_rounded),
                    SizedBox(width: 5),
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
                    Text("About Device"),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          recommendationType == null
              ? SizedBox()
              : Row(
                  children: [
                    Text(
                      recommendationType!,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
          SizedBox(
            height: 5,
          ),
          Obx(
            () {
              return Column(
                // animationDuration: Duration(seconds: 2),
                children: controller.recommendations
                    .map<Widget>((RecommendationModel e) {
                  return ExpansionCard(recommendationData: e);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
