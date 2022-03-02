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
                        title: "warning".tr,
                        middleText:
                            "data-access-warning-text".tr,
                        middleTextStyle: TextStyle(color: Colors.red),
                        confirm: OutlinedButton(
                            onPressed: () async {
                              bool result =
                                  await controller.updateDataAccess(value);
                              Get.back();
                              if (!Get.isSnackbarOpen) {
                                result
                                    ? Get.snackbar("data-access-title".tr,
                                        "data-access-success-text".tr,
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.greenAccent)
                                    : Get.snackbar("data-access-title".tr,
                                        "data-access-failed-text".tr,
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.orangeAccent);
                              }
                            },
                            child: Text("ok".tr)),
                        cancel: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("cancel".tr)),
                      );
                    } else {
                      bool result = await controller.updateDataAccess(value);

                      if (!Get.isSnackbarOpen) {
                        result
                            ? Get.snackbar(
                            "data-access-title".tr, "data-access-success-text".tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.greenAccent)
                            : Get.snackbar(
                            "data-access-title".tr, "data-access-failed-text".tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orangeAccent);
                      }
                    }
                  },
                  defaultValue: controller.getDataAccess,
                  permission: controller.getDataAccess,
                  label: "data-access-processing-title".tr,
                  description: "data-access-processing-desc".tr,
                ),
                Divider(
                  height: 5.0,
                  color: Colors.black,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText("data-sharing-title".tr),
                    CustomLabeledRadio(
                      value: 0,
                      label: "do-not-share".tr,
                      description:
                          "do-not-shar-desc".tr,
                      groupValue: controller.isRadioSelected.value,
                      onChanged: (int newValue) {
                        controller.isRadioSelected.value != newValue
                            ? Get.defaultDialog(
                                barrierDismissible: false,
                                title: "warning".tr,
                                middleText:
                                    "do-not-share-warning-dialog".tr,
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
                                    child: Text("ok".tr)),
                                cancel: TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("cancel".tr)),
                              )
                            : controller.isRadioSelected.value = newValue;
                        controller.updateDoNotShare(1);
                      },
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    CustomLabeledRadio(
                      value: 1,
                      label: "replicate-between-your-devices".tr,
                      description: "replicate-between-your-devices-desc".tr,
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
                                ? Get.snackbar("replication".tr,
                                "replication-success-text".tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.greenAccent)
                                : Get.snackbar("replication".tr,
                                "replication-failed-text".tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orangeAccent);
                          }
                        };
                      }
                          : (int a) {
                              Get.defaultDialog(
                                barrierDismissible: false,
                                title: "alert".tr,
                                middleText:
                                "info-alert-needs-permission".tr,
                                middleTextStyle: TextStyle(color: Colors.red),
                                cancel: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("ok".tr)),
                              );
                            },
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    CustomLabeledRadio(
                      value: 2,
                      label: 'share-data-with-cloud'.tr,
                      description:
                          "share-data-with-cloud-desc".tr,
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
                                title: "alert".tr,
                                middleText: "info-alert-needs-permission".tr,
                                middleTextStyle: TextStyle(color: Colors.red),
                                cancel: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("ok".tr)),
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
                    boldText("tools-may-process-data".tr),
                    Row(
                      children: [
                        Expanded(
                          child: Text("tools-may-process-data-desc".tr,
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
                          child: Text("tools".tr),
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
                    boldText("incident-reporting".tr),
                    Text("incident-reporting-desc".tr),
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
                              title: "alert".tr,
                              middleText:
                                  "info-alert-needs-permission".tr,
                              middleTextStyle: TextStyle(color: Colors.red),
                              cancel: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("ok".tr)),
                            );
                          },
                    child: Text("navigate-to-scan-screen".tr)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
