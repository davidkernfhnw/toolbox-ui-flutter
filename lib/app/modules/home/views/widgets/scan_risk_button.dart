import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ScanRiskButton extends StatelessWidget {
  final HomeController controller;
  final Color changeScanBtnColor;

  ScanRiskButton(
      {Key? key, required this.controller, required this.changeScanBtnColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          CircularPercentIndicator(
            animationDuration: 500,
            animation: true,
            radius: 100.0,
            lineWidth: 3.0,
            percent: controller.aggThreatsScore.value.threatScores.isEmpty
                ? 0.0
                : 1.0,
            progressColor: controller.isScanRequired.value == false
                ? changeScanBtnColor
                : Colors.red,
            center: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary:
                    controller.dataProcess.value && controller.dataAccess.value
                        ? changeScanBtnColor
                        : Colors.grey,
              ),
              onPressed: controller.dataProcess.value &&
                      controller.dataAccess.value
                  ? controller.onScanButtonPressed
                  : () {
                      if (!Get.isDialogOpen!) {
                        Get.defaultDialog(
                          barrierDismissible: false,
                          // content: Text("Geiger Toolbox need access to your data."
                          //     "Please enable Data Access and Data Processing in the Settings Screen"),
                          middleText:
                              "Geiger Toolbox needs access to your data. Please grant Permission",
                          confirm: ElevatedButton(
                              onPressed: () {
                                Get.offNamed(Routes.SETTINGS_VIEW);
                              },
                              child: Text("Data Protection")),
                          cancel: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.orangeAccent)),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Cancel")),
                        );
                      }
                    },
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    controller.dataAccess.value && controller.dataProcess.value
                        ? 'Scan Threat'
                        : "Grant Permission",
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
              child: controller.isScanRequired.value == true
                  ? Icon(
                      Icons.warning_sharp,
                      size: 30,
                      color: Colors.red,
                    )
                  : Container(),
            ),
          ),
        ],
      );
    });
  }
}
