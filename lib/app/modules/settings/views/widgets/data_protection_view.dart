import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/data_protection_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_radio_list_tile.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_switch.dart';
import 'package:geiger_toolbox/app/shared_widgets/showCircularProgress.dart';
import 'package:geiger_toolbox/app/util/style.dart';
import 'package:get/get.dart';

import '../../../../services/internetConnection/internet_connection_controller.dart';

class DataProtectionView extends StatelessWidget {
  DataProtectionView({Key? key}) : super(key: key);

  final DataProtectionController controller = DataProtectionController.instance;
  final DataProtectionController _dataProtectionController = DataProtectionController.instance;
  final InternetConnectionController _internetConnectionController = InternetConnectionController.instance;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomSwitch(
                  onChanged: (bool value) async {
                    //check if granted
                    if (_dataProtectionController.getDataAccess) {
                      Get.defaultDialog(
                        barrierDismissible: false,
                        title: "Warning",
                        middleText:
                            "Are you sure you want to disable Data Access and Processing?\n"
                            "The setting will be applied after you restart the app.",
                        middleTextStyle: TextStyle(color: Colors.red),
                        confirm: OutlinedButton(
                            onPressed: () async {
                              bool result =
                                  await controller.updateDataAccess(value);
                              Get.back();
                              if (!Get.isSnackbarOpen) {
                                result
                                    ? Get.snackbar("Data Access",
                                        "Consent successfully updated.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.greenAccent)
                                    : Get.snackbar("Data Access",
                                        "Consent fail to update.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.orangeAccent);
                              }
                            },
                            child: Text("ok")),
                        cancel: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("Cancel")),
                      );
                    } else {
                      bool result = await controller.updateDataAccess(value);

                      if (!Get.isSnackbarOpen) {
                        result
                            ? Get.snackbar(
                                "Data Access", "Consent successfully updated.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.greenAccent)
                            : Get.snackbar(
                                "Data Access", "Consent fail to update.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orangeAccent);
                      }
                    }
                  },
                  defaultValue: controller.getDataAccess,
                  permission: controller.getDataAccess,
                  label: 'Data Access and Processing',
                  description:
                      'Allow the toolbox to calculate your risk score and receive protection recommendations.',
                ),
                Divider(
                  height: 5.0,
                  color: Colors.black,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText("Data Sharing"),
                    CustomLabeledRadio(
                      value: 0,
                      label: 'Do not Share',
                      description:
                          'Data will remain on this single device only.',
                      groupValue: controller.isRadioSelected.value,
                      onChanged: (int newValue) {
                        controller.isRadioSelected.value != newValue
                            ? Get.defaultDialog(
                                barrierDismissible: false,
                                title: "Warning",
                                middleText:
                                    "Are you sure you want to stop your data from be replicated ?\n"
                                    "The setting will be applied after you restart the app.",
                                middleTextStyle: TextStyle(color: Colors.red),
                                confirm: OutlinedButton(
                                    onPressed: () async {
                                      controller.isRadioSelected.value =
                                          newValue;
                                      await controller.updateDoNotShare(0);
                                      await controller
                                          .updateReplicateConsent(1);
                                      Get.back();
                                    },
                                    child: Text("ok")),
                                cancel: TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("Cancel")),
                              )
                            : controller.isRadioSelected.value = newValue;
                        controller.updateDoNotShare(1);
                      },
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    CustomLabeledRadio(
                      value: 1,
                      label: 'Replicate securely between your devices.',
                      description:
                          "All your data will be available on all your devices.",
                      groupValue: controller.isRadioSelected.value,
                      onChanged: _dataProtectionController.getDataAccess
                          ? (int newValue) async {
                        //check internet connection
                        if (await _internetConnectionController.isInternetConnected()) {
                        ShowCircularProgress.buildShowDialog(context);
                        controller.isRadioSelected.value = newValue;

                        await controller.updateReplicateConsent(0);
                          await controller.updateDoNotShare(1);
                          bool? success =
                          await controller.initReplication();
                          Get.back();
                          if (!Get.isSnackbarOpen) {
                            success
                                ? Get.snackbar("Replication",
                                "Your data was successfully replicated.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.greenAccent)
                                : Get.snackbar("Replication",
                                "Your data replication failed.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orangeAccent);
                          }
                        };
                      }
                          : (int a) {
                              Get.defaultDialog(
                                barrierDismissible: false,
                                title: "Alert ",
                                middleText:
                                    "Toolbox needs you to grant permission for data access and processing.",
                                middleTextStyle: TextStyle(color: Colors.red),
                                cancel: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("ok")),
                              );
                            },
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    CustomLabeledRadio(
                      value: 2,
                      label: 'Share data with GEIGER cloud.',
                      description:
                          "Your tools’ data will be used to improve GEIGER over time.",
                      groupValue: controller.isRadioSelected.value,
                      onChanged: _dataProtectionController.getDataAccess
                          ? (int newValue) async {
                              //check internet connection
                              await _internetConnectionController.isInternetConnected();
                              controller.isRadioSelected.value = newValue;
                            }
                          : (int a) {
                              Get.defaultDialog(
                                barrierDismissible: false,
                                title: "Alert ",
                                middleText:
                                    "Toolbox needs you to grant permission for data access and processing.",
                                middleTextStyle: TextStyle(color: Colors.red),
                                cancel: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("ok")),
                              );
                            },
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                  ],
                ),
                Divider(
                  height: 5.0,
                  color: Colors.black,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText('Tools may process  your data'),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'This setting enables or disables the tools’ ability to process your data and offer personalised services. When enabled, you can disable the setting for each tool.',
                            softWrap: true,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        ElevatedButton(
                          onPressed: _dataProtectionController.getDataAccess
                              ? () {
                                  Get.toNamed(Routes.TOOLS_VIEW);
                                }
                              : null,
                          child: Text("Tools"),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 5.0,
                  color: Colors.black,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText('Incident reporting'),
                    Text(
                        'When experiencing an incident, you will have the ability to submit an incident report to your chosen cybersecurity agency (CERT). You will be asked each time whether you want to report the incident.'),
                  ],
                ),
                ElevatedButton(
                    onPressed: _dataProtectionController.getDataAccess
                        ? () {
                            Get.toNamed(Routes.HOME_VIEW);
                          }
                        : () {
                            Get.defaultDialog(
                              barrierDismissible: false,
                              title: "Alert ",
                              middleText:
                                  "Toolbox needs you to grant permission for data access and processing.",
                              middleTextStyle: TextStyle(color: Colors.red),
                              cancel: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("ok")),
                            );
                          },
                    child: Text("Navigate to Scan Screen")),
              ],
            ),
          );
        }),
      ),
    );
  }
}
