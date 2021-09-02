import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'scan_risk_button.dart';

class TopScreen extends StatelessWidget {
  final String? aggregratedScore;
  final void Function()? onScanPressed;
  final bool? warming;

  const TopScreen(
      {Key? key,
      @required this.aggregratedScore,
      @required this.onScanPressed,
      @required this.warming})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Your total Risk Score:',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 5.0),
        GradientText(
          aggregratedScore!,
          style: TextStyle(
            fontSize: 34.0,
            fontWeight: FontWeight.w700,
          ),
          colors: [
            Color(0xffD92323),
            Color(0xffD92323),
          ],
        ),
        SizedBox(height: 5.0),
        ScanRiskButton(
          onScanPressed: onScanPressed,
          warming: warming,
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: null,
              child: Text(
                'Employee Scores',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            OutlinedButton(
              onPressed: null,
              autofocus: true,
              child: Text(
                'Device Scores',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Current Threats',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              'Threat Levels',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
