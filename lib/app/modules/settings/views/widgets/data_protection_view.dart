import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/data_protection_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_radio_list_tile.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_switch.dart';
import 'package:geiger_toolbox/app/shared_widgets/showCircularProgress.dart';
import 'package:geiger_toolbox/app/util/style.dart';
import 'package:get/get.dart';

class DataProtectionView extends StatelessWidget {
  DataProtectionView({Key? key}) : super(key: key);

  final DataProtectionController controller = DataProtectionController.instance;
  final DataProtectionController _dataProtectionController =
      DataProtectionController.instance;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Obx(() {
          return controller.isLoading.value || controller.isLoading.value
              ? ShowCircularProgress(visible: true)
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CustomSwitch(
                        onChanged: (bool value) async {
                          bool result =
                              await controller.updateDataAccess(value);

                          if (!Get.isSnackbarOpen) {
                            result
                                ? Get.snackbar("Data Access",
                                    "Consent successfully updated.",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.greenAccent)
                                : Get.snackbar(
                                    "Data Access", "Consent fail to update.",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.orangeAccent);
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
                              controller.isRadioSelected.value = newValue;
                            },
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                          CustomLabeledRadio(
                            value: 1,
                            label: 'Replicate securely between your devices.',
                            description:
                                "All your data will be available on all your devices.",
                            groupValue: controller.isRadioSelected.value,
                            onChanged: (int newValue) {
                              controller.isRadioSelected.value = newValue;
                            },
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                          CustomLabeledRadio(
                            value: 2,
                            label: 'Share data with GEIGER cloud.',
                            description:
                                "Your tools’ data will be used to improve GEIGER over time.",
                            groupValue: controller.isRadioSelected.value,
                            onChanged: (int newValue) {
                              controller.isRadioSelected.value = newValue;
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
                                onPressed:
                                    _dataProtectionController.getDataAccess
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
                                    title: "Grant Toolbox ",
                                    middleText: "Data Access and Processing",
                                    middleTextStyle:
                                        TextStyle(color: Colors.red),
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
