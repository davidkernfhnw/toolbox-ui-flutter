import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/data_protection_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_switch.dart';
import 'package:geiger_toolbox/app/util/style.dart';
import 'package:get/get.dart';

class DataProtectionView extends StatelessWidget {
  final DataProtectionController controller;
  const DataProtectionView({Key? key, required this.controller})
      : super(key: key);

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
                    bool result = await controller.updateDataAccess(value);

                    if (!Get.isSnackbarOpen) {
                      result
                          ? Get.snackbar(
                              "Data Access", "Consent successfully updated.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green)
                          : Get.snackbar(
                              "Data Access", "Consent fail to update.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orangeAccent);
                    }
                  },
                  defaultValue: controller.getDataAccess,
                  label: 'This toolbox may be access your data',
                  description:
                      'This setting gives you the ability to work with the toolbox, pair devices, install tools, find people who could support you.',
                ),
                Divider(
                  height: 5.0,
                  color: Colors.black,
                ),
                CustomSwitch(
                  onChanged: (bool value) async {
                    bool result = await controller.updateDataProcess(value);
                    if (!Get.isSnackbarOpen) {
                      result
                          ? Get.snackbar(
                              "Data Process", "Consent successfully updated.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green)
                          : Get.snackbar(
                              "Data Process", "Consent fail to updated.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orangeAccent);
                    }
                  },
                  defaultValue: controller.getDataProcess,
                  label: 'This toolbox may be process your data',
                  description:
                      'This setting gives you the ability to calculate your risk score and receive protection recommendations.',
                ),
                Divider(
                  height: 5.0,
                  color: Colors.black,
                ),
                CustomSwitch(
                  onChanged: null,
                  defaultValue: false,
                  label: 'The GEIGER cloud may access your data',
                  description:
                      'This setting shares your anonymize data with the GEIGER cloud. The setting gives you the ability to increase the accuracy of the risk score and more complete recommendations',
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
                          onPressed: null,
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
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
