import 'package:flutter/material.dart';

import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ScanRiskButton extends StatelessWidget {
  final void Function()? onScanPressed;
  final bool? warming;

  // getting an instance of HomeController
  final HomeController controller = HomeController.to;

  ScanRiskButton(
      {Key? key, @required this.onScanPressed, @required this.warming})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircularPercentIndicator(
          animationDuration: 500,
          animation: true,
          radius: 100.0,
          lineWidth: 3.0,
          percent: controller.threatsScore.isEmpty ? 0.0 : 1.0,
          progressColor: warming == false ? Colors.green : null,
          center: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: warming == false ? Colors.green : Colors.red,
            ),
            onPressed: onScanPressed,
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Center(
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
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: warming == true
                ? const Icon(
                    Icons.warning_sharp,
                    size: 30,
                    color: Colors.redAccent,
                  )
                : Container(),
          ),
        ),
      ],
    );
  }
}
