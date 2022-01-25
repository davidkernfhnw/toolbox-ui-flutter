import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:pretty_gauge/pretty_gauge.dart';

class IndicatorGauge extends StatelessWidget {
  final double? score;
  IndicatorGauge({Key? key, @required this.score}) : super(key: key);
  // getting an instance of HomeController
  final HomeController _controller = HomeController.instance;

  String get level {
    String level = _controller.checkAggScoreLevel(score.toString());
    return level;
  }

  Color get levelColor {
    Color color = _controller.changeScanBtnColor(score.toString());
    return color;
  }

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
        displayWidget:
            Text(level, style: TextStyle(fontSize: 12, color: levelColor)),
        showMarkers: false);
  }
}
