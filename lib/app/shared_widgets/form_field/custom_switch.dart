import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch(
      {required this.fieldBuilderName,
      this.label,
      required this.description,
      Key? key})
      : super(key: key);

  final String fieldBuilderName;
  final String? label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        boldText(label ?? ''),
        FormBuilderSwitch(
          name: fieldBuilderName,
          initialValue: false,
          title: Text(description),
        ),
      ],
    );
  }
}
