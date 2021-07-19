import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircularPercentIndicator(
          animation: true,
          radius: 100.0,
          lineWidth: 2.0,
          percent: 1.0,
          center: TextButton(
            onPressed: null,
            child: Card(
              color: Colors.green,
              elevation: 4.0,
              shape: CircleBorder(),
              child: Center(
                child: Text(
                  'Scan Threat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          progressColor: Colors.green,
        ),
        Positioned(
          right: -12,
          top: 8,
          child: Container(
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: Icon(
              Icons.warning_sharp,
              size: 30,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
