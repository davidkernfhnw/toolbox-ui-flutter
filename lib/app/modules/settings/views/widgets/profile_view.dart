import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_dropdown_country.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_dropdown_partners.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_switch.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_text_field.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/cutom_dropdown_language.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  ProfileView({required this.controller, Key? key}) : super(key: key);
  final SettingsController controller;
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
                  hintText: "Enter username",
                  label: 'User Name',
                  initialValue: controller.userInfo.value.userName ?? "",
                  onChanged: controller.onChangeUserName,
                  validator: controller.validateUserName,
                ),
                CustomTextField(
                  hintText: "deviceName",
                  label: 'Name of this Device',
                  initialValue: controller.currentDeviceName.value,
                  onChanged: controller.onChangeDeviceName,
                  validator: controller.validateDeviceName,
                ),
                CustomSwitchs(
                  label: "I’m a company owner",
                  description:
                      "As an owner you can compare your company’s geiger score with others ",
                  defaultValue: controller.supervisor.value,
                  onChanged: controller.onChangeOwner,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomDropdownLanguage(
                  listItems: controller.languages,
                  titleText: "Language",
                  onChanged: controller.onChangeLanguage,
                  defaultValue: controller.userInfo.value.language,
                  hintText: '',
                ),
                SizedBox(
                  height: 15,
                ),
                CustomDropDownCountry(
                  listItems: controller.c,
                  onChanged: controller.onChangedCountry,
                  hintText: 'Select Your Country',
                  titleText: "Country",
                  defaultValue: controller.currentCountry.value,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomDropDownFlutter(
                  onChanged: controller.onChangedCert,
                  listItems: controller.certBaseOnCountrySelected,
                  defaultValue: controller.currentCert.value,
                  hintText: "Select Competent CERT",
                  titleText: "Competent CERT",
                ),
                SizedBox(
                  height: 15,
                ),
                CustomDropDownFlutter(
                  onChanged: controller.onChangedProfAss,
                  listItems: controller.profAssBaseOnCountrySelected,
                  defaultValue: controller.currentProfAss.value,
                  hintText: "Select Profession Association",
                  titleText: "Profession Association",
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.updateUserInfo(controller.userInfo.value);
                      if (controller.isSuccess.value == true) {
                        Get.snackbar("Success", "Updated SuccessFully.",
                            backgroundColor: Colors.greenAccent);
                      } else {
                        Get.snackbar("Message Alert",
                            "Updated Failed!!!.. contact the Developer",
                            backgroundColor: Colors.redAccent);
                      }
                    }
                  },
                  child: Text("Update"),
                ),
                SizedBox(height: 10),
              ],
            );
          }),
        ),
      ),
    );
  }
}
