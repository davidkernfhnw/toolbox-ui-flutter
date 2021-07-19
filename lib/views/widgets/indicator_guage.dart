import 'package:flutter/material.dart';
import 'package:pretty_gauge/pretty_gauge.dart';

class IndicatorGauge extends StatelessWidget {
  final double? score;
  IndicatorGauge({@required this.score});

  @override
  Widget build(BuildContext context) {
    return PrettyGauge(
        gaugeSize: 100,
        segments: [
          GaugeSegment('Low', 30, Colors.red),
          GaugeSegment('Medium', 40, Colors.orange),
          GaugeSegment('High', 30, Colors.green),
        ],
        currentValue: score,
        displayWidget: Text('High', style: TextStyle(fontSize: 12)),
        showMarkers: false);
  }
}
