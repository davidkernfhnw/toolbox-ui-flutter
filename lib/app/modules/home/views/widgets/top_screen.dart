import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:geiger_toolbox/app/util/style.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'scan_risk_button.dart';

class TopScreen extends StatelessWidget {
  final HomeController controller;

  final void Function()? onChangeUserId;

  const TopScreen({Key? key, this.onChangeUserId, required this.controller})
      : super(key: key);

  String get parseToDouble {
    //convert to geiger_score aggregate to double
    double a = double.parse(controller.aggThreatsScore.value.geigerScore);
    //back to String with precision
    String agg = a.toPrecision(1).toString();
    return agg;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Text(
            controller.dataAccess.value && controller.dataProcess.value
                ? parseToDouble != "0.0"
                    ? 'Your total Risk Score:'
                    : 'Start scanning your cyber threats:'
                : "Permission is required before Geiger Toolbox can process your data.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color:
                    controller.dataAccess.value && controller.dataProcess.value
                        ? Colors.grey
                        : Colors.deepOrangeAccent,
                fontWeight: FontWeight.bold),
          ),
          !controller.isScanning.value
              ? GradientText(
                  !controller.isScanning.value
                      ? parseToDouble == "0.0"
                          ? ""
                          : parseToDouble
                      : "",
                  style: const TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.w700,
                  ),
                  colors: [
                    controller.changeScanBtnColor(parseToDouble),
                    controller.changeScanBtnColor(parseToDouble),
                  ],
                )
              : greyText("Scanning...."),
          const SizedBox(height: 5.0),
          ScanRiskButton(
            controller: controller,
            changeScanBtnColor: controller.changeScanBtnColor(parseToDouble),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: onChangeUserId,
                child: Text(
                  'update currentUserId ',
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
    });
  }
}
