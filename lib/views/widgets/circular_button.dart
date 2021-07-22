import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularButton extends StatelessWidget {
  final void Function()? onScanPressed;
  final Color? scanColor;

  const CircularButton({Key? key, @required this.onScanPressed, this.scanColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircularPercentIndicator(
          animation: true,
          radius: 100.0,
          lineWidth: 3.0,
          percent: 1.0,
          progressColor: scanColor == null ? Colors.green : scanColor,
          center: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              primary: scanColor,
            ),
            onPressed: onScanPressed,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Center(
                child: Text(
                  'Scan Threat',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
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
