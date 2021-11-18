import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/country_drop_down.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_switch.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_text_field.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/language_drop_down.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/partners_drop_down.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  ProfileView({required this.controller, Key? key}) : super(key: key);
  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return FormBuilder(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Obx(() {
          return Column(
            children: [
              CustomTextField(
                fieldBuilderName: 'userName',
                defaultValue: controller.userInfo.value.userName ?? "Nosa",
                hintText: "Enter username",
                label: 'User Name',
              ),
              CustomTextField(
                fieldBuilderName: 'deviceName',
                defaultValue:
                    controller.userInfo.value.deviceOwner.name ?? "check",
                hintText: "auto get deviceName",
                label: 'Name of this Device',
              ),
              CustomSwitch(
                onChanged: controller.onSwitchOwner,
                fieldBuilderName: 'companyOwner',
                description:
                    'As an owner you can compare your company’s geiger score with others ',
                label: "I'm a company owner",
                defaultValue: controller.userInfo.value.supervisor,
              ),
              SizedBox(
                height: 20,
              ),
              LanguageDropDown(
                  fieldBuilderName: 'languageSelected',
                  defaultValue: controller.selectedLanguage.value,
                  titleText: "language",
                  onChanged: controller.onChangeLanguage,
                  listItems: controller.languages,
                  hintText: "Select language"),
              SizedBox(
                height: 10,
              ),
              CountryDropDown(
                  fieldBuilderName: 'countries',
                  defaultValue: controller.userInfo.value.country ?? "",
                  titleText: "Country",
                  onChanged: controller.onChangedCountry,
                  listItems: controller.countries,
                  hintText: "Select Country"),
              SizedBox(
                height: 10,
              ),
              PartnersDropDown(
                  fieldBuilderName: 'competentCert',
                  titleText: "Competent CERT",
                  defaultValue: controller.userInfo.value.cert ??
                      controller.currentCert.value,
                  onChanged: null,
                  listItems: controller.certBaseOnCountrySelected,
                  hintText: "Select Competent CERT"),
              SizedBox(
                height: 10,
              ),
              PartnersDropDown(
                  fieldBuilderName: 'professionalAssociation',
                  defaultValue: controller.userInfo.value.profAss ??
                      controller.currentProfAss.value,
                  titleText: "Professional Association",
                  onChanged: null,
                  listItems: controller.profAssBaseOnCountrySelected,
                  hintText: "Select Professional Association"),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(onPressed: null, child: Text("Update")),
            ],
          );
        })),
      ),
    );
  }
}
