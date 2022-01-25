import 'package:flutter/material.dart';
import 'package:pretty_gauge/pretty_gauge.dart';

class IndicatorGauge extends StatelessWidget {
  const IndicatorGauge({Key? key, @required this.score}) : super(key: key);
  final double? score;
  @override
  Widget build(BuildContext context) {
    return PrettyGauge(
        gaugeSize: 100,
        segments: [
          GaugeSegment('High', 30, Colors.green),
          GaugeSegment('Medium', 40, Colors.orange),
          GaugeSegment('Low', 30, Colors.red),
        ],
        currentValue: score,
        displayWidget: const Text('High', style: TextStyle(fontSize: 12)),
        showMarkers: false);
  }
}
