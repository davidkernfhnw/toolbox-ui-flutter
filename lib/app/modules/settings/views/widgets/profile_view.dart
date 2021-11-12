import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_drop_down.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_switch.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_text_field.dart';

class ProfileView extends StatelessWidget {
  ProfileView({required this.controller, Key? key}) : super(key: key);
  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return FormBuilder(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                fieldBuilderName: 'userName',
                hintText: "Enter username",
                label: 'User Name',
              ),
              CustomTextField(
                fieldBuilderName: 'deviceName',
                hintText: "auto get deviceName",
                label: 'Name of this Device',
              ),
              CustomSwitch(
                fieldBuilderName: 'companyOwner',
                description:
                    'As an owner you can compare your company’s geiger score with others ',
                label: "I'm a company owner",
              ),
              SizedBox(
                height: 20,
              ),
              CustomDropDown(
                  fieldBuilderName: 'language',
                  titleText: "language",
                  listItems: ["english"],
                  hintText: "Select language"),
              SizedBox(
                height: 10,
              ),
              CustomDropDown(
                  fieldBuilderName: 'competentCert',
                  listItems: ["english"],
                  hintText: "Select Competent CERT"),
              SizedBox(
                height: 10,
              ),
              CustomDropDown(
                  fieldBuilderName: 'professionalAssociation',
                  listItems: ["english"],
                  hintText: "Select Professional Association"),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(onPressed: null, child: Text("Update")),
            ],
          ),
        ),
      ),
    );
  }
}
