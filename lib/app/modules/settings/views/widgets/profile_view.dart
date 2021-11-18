import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/country_drop_down.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_text_field.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/language_drop_down.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/partners_drop_down.dart';
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
          key: _formKey,
          child: Obx(() {
            return Column(
              children: [
                CustomTextFieldFlutter(
                    hintText: "Enter username",
                    label: 'User Name',
                    textEditingController: controller.userName
                      ..text = controller.userInfo.value.userName ?? "user"),
                CustomTextFieldFlutter(
                  hintText: "auto get deviceName",
                  label: 'Name of this Device',
                  textEditingController: controller.deviceName
                    ..text = controller.userInfo.value.deviceOwner.name ?? "ok",
                ),
                CustomDropdownLanguage(
                  listItems: controller.languages,
                  titleText: "Language",
                  onChanged: controller.onChangeLanguage,
                  defaultValue: controller.selectedLanguage.value,
                  hintText: '',
                ),
                SizedBox(
                  height: 15,
                ),
                CustomDropDownCountry(
                  listItems: controller.countries,
                  onChanged: controller.onChangedCountry,
                  hintText: 'Select Your Country',
                  titleText: "Country",
                  defaultValue:
                      controller.userInfo.value.country ?? "Switzerland",
                ),
                SizedBox(
                  height: 15,
                ),
                CustomDropDownFlutter(
                  onChanged: controller.onChangedCert,
                  listItems: controller.certBaseOnCountrySelected,
                  defaultValue: controller.userInfo.value.cert ??
                      controller.currentCert.value,
                  hintText: "Select Competent CERT",
                  titleText: "Competent CERT",
                ),
                SizedBox(
                  height: 15,
                ),
                CustomDropDownFlutter(
                  onChanged: controller.onChangedProfAss,
                  listItems: controller.profAssBaseOnCountrySelected,
                  defaultValue: controller.userInfo.value.profAss ??
                      controller.currentProfAss.value,
                  hintText: "Select Profession Association",
                  titleText: "Profession Association",
                ),
                OutlinedButton(onPressed: null, child: Text("Update")),
              ],
            );
          }),
        ),
      ),
    );
  }
}
