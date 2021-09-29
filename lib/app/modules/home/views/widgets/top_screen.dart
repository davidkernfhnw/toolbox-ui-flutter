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
        const Text(
          'Your total Risk Score:',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 5.0),
        GradientText(
          aggregratedScore!,
          style: const TextStyle(
            fontSize: 34.0,
            fontWeight: FontWeight.w700,
          ),
          colors: const [
            Color(0xffD92323),
            Color(0xffD92323),
          ],
        ),
        const SizedBox(height: 5.0),
        ScanRiskButton(
          onScanPressed: onScanPressed,
          warming: warming,
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
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
        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
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
