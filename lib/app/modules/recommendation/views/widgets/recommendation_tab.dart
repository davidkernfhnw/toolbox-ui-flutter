import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/recommendations_models.dart';

import 'package:geiger_toolbox/app/shared_widgets/indicator_gauge.dart';
import 'package:get/get.dart';
import 'expansion_card.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;

class RecommendationTab extends StatelessWidget {
  final String label;
  final double score;
  final String threatTitle;
  final String? recommendationType;
  final List<dummy.Recommendations> recommendations;

  const RecommendationTab({
    Key? key,
    required this.recommendations,
    required this.label,
    required this.score,
    required this.threatTitle,
    this.recommendationType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                    const Icon(Icons.warning_rounded),
                    const SizedBox(width: 5),
                    Text("About $threatTitle"),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: null,
                child: Row(
                  children: const [
                    Icon(Icons.warning_rounded),
                    SizedBox(width: 5),
                    Text("About Device"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          recommendationType == null
              ? const SizedBox()
              : Row(
                  children: [
                    Text(
                      recommendationType!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
          const SizedBox(
            height: 5,
          ),
          Column(
            // animationDuration: Duration(seconds: 2),
            children: recommendations.map<Widget>((dummy.Recommendations e) {
              return ExpansionCard(recommendations: e);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
