import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch(
      {required this.fieldBuilderName,
      this.label,
      required this.description,
      this.defaultValue,
      required this.onChanged,
      Key? key})
      : super(key: key);

  final String fieldBuilderName;
  final String? label;
  final String description;
  final bool? defaultValue;
  final void Function(bool? value)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        boldText(label ?? ''),
        FormBuilderSwitch(
          name: fieldBuilderName,
          initialValue: defaultValue,
          onChanged: onChanged,
          title: Text(description),
        ),
      ],
    );
  }
}

class CustomSwitchs extends StatelessWidget {
  const CustomSwitchs(
      {Key? key,
      required this.label,
      this.description,
      required this.defaultValue,
      this.onChanged})
      : super(key: key);
  final String label;
  final String? description;
  final bool defaultValue;
  final void Function(bool value)? onChanged;
  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: boldText(label),
      subtitle: greyText(description ?? ""),
      onChanged: onChanged,
      value: defaultValue,
    );
  }
}
