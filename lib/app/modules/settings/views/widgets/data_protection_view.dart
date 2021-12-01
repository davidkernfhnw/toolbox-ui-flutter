import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_switch.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class DataProtectionView extends StatelessWidget {
  const DataProtectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return FormBuilder(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomSwitch(
                onChanged: null,
                fieldBuilderName: 'accessData',
                label: 'This toolbox may be access your data',
                description:
                    'This setting gives you the ability to work with the toolbox, pair devices, install tools, find people who could support you.',
              ),
              CustomSwitch(
                onChanged: null,
                fieldBuilderName: 'processData',
                label: 'This toolbox may be process your data',
                description:
                    'This setting gives you the ability to calculate your risk score and receive protection recommendations.',
              ),
              CustomSwitch(
                onChanged: null,
                fieldBuilderName: 'CloudData',
                label: 'The GEIGER cloud may access your data',
                description:
                    'This setting shares your anonymize data with the GEIGER cloud. The setting gives you the ability to increase the accuracy of the risk score and more complete recommendations',
              ),
              CustomSwitch(
                onChanged: null,
                fieldBuilderName: 'toolsData',
                label: 'Tools may process  your data',
                description:
                    'This setting enables or disables the tools’ ability to process your data and offer personalised services. When enabled, you can disable the setting for each tool.',
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
        ),
      ),
    );
  }
}
