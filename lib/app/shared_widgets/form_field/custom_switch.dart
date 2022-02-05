import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch(
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
      isThreeLine: true,
      subtitle: Text(
        description ?? "",
        softWrap: true,
        textAlign: TextAlign.justify,
        style: TextStyle(color: Colors.black),
      ),
      onChanged: onChanged,
      value: defaultValue,
      contentPadding: EdgeInsets.all(0),
    );
  }
}
