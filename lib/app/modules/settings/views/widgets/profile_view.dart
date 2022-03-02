import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/profile_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_dropDown_prof_ass.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_dropdown_cert.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_dropdown_country.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_switch.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_text_field.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/cutom_dropdown_language.dart';
import 'package:get/get.dart';

import '../../controllers/data_protection_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);
  final ProfileController controller = ProfileController.instance;
  final DataProtectionController _dataProtectionController =
      DataProtectionController.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    //final formKey = GlobalKey<FormBuilderState>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // onChanged: () {
              //   log("listening to changes in full form");
              // },
              key: _formKey,
              child: Obx(() {
                return Column(
                  children: [
                    CustomTextField(
                      hintText: controller.currentUserName.value == ""
                          ? "user-name-hint".tr
                          : "",
                      label: 'user-name-label'.tr,
                      initialValue: controller.currentUserName.value,
                      onChanged: controller.onChangeUserName,
                      validator: controller.validateUserName,
                    ),
                    CustomTextField(
                      hintText: controller.currentDeviceName.value == ""
                      ? "device-name-hint".tr
                      : "",
                      label: 'device-name-label'.tr,
                      initialValue: controller.currentDeviceName.value,
                      onChanged: controller.onChangeDeviceName,
                      validator: controller.validateDeviceName,
                    ),
                    CustomSwitch(
                      label: "company-owner".tr,
                      description: "company-owner-desc".tr,
                      defaultValue: controller.supervisor.value,
                      onChanged: controller.onChangeOwner,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomDropdownLanguage(
                      listItems: controller.languages,
                      titleText: "language".tr,
                      onChanged: controller.onChangeLanguage,
                      defaultValue: controller.userInfo.value.language,
                      hintText: '',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomDropDownCountry(
                      countries: controller.currentCountries,
                      onChanged: controller.onChangedCountry,
                      hintText: 'select-your-country'.tr,
                      titleText: "country".tr,
                      defaultValue: controller.currentCountryId.value,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomDropDownCert(
                      onChanged: controller.onChangedCert,
                      certs: controller.certBaseOnCountrySelected,
                      defaultValue: controller.currentCert.value,
                      hintText: "select-competent-cert".tr,
                      titleText: "competent-cert".tr,
                      validator: controller.validateCert,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomDropDownProfAss(
                        onChanged: controller.onChangedProfAss,
                        certs: controller.profAssBaseOnCountrySelected,
                        defaultValue: controller.currentProfAss.value,
                        hintText: "select-profession-association".tr,
                        titleText: "profession-association".tr,
                        validator: controller.validateProfAss),
                    ElevatedButton(
                      onPressed: _dataProtectionController.getDataAccess
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                controller
                                    .updateUserInfo(controller.userInfo.value);
                                if (controller.isSuccess.value == true) {
                                  if (!Get.isSnackbarOpen) {
                                    Get.snackbar(
                                        "success".tr, "updated-successfully".tr,
                                        backgroundColor: Colors.greenAccent,
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                } else {
                                  Get.snackbar("message-alert".tr,
                                      "update-failed-contact-developer".tr,
                                      backgroundColor: Colors.redAccent);
                                }
                              }
                            }
                          : null,
                      child: Text("update".tr),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }))),
    );
  }
}
