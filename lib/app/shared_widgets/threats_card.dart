import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'indicator_guage.dart';

class ThreatsCard extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final double? indicatorScore;
  final String? routeName;
  const ThreatsCard(
      {Key? key,
      @required this.label,
      @required this.icon,
      @required this.indicatorScore,
      @required this.routeName})
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                  onPressed: () => Get.toNamed(routeName!),
                  child: Text("Improve"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
