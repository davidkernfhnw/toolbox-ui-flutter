import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geiger_toolbox/app/data/model/language.dart';

class LanguageDropDown extends StatelessWidget {
  LanguageDropDown(
      {required this.fieldBuilderName,
      this.titleText,
      required this.listItems,
      required this.hintText,
      this.defaultValue,
      this.onChanged,
      Key? key})
      : super(key: key);

  final String fieldBuilderName;
  final String? titleText;
  final List<Language> listItems;
  final String hintText;
  final String? defaultValue;
  final void Function(String? language)? onChanged;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      name: fieldBuilderName,
      decoration: InputDecoration(
        labelText: titleText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      initialValue: defaultValue,
      allowClear: true,
      onChanged: onChanged,
      hint: Text(hintText),
      items: listItems
          .map((Language item) => DropdownMenuItem(
                value: item.symbol,
                child: Text(item.language),
              ))
          .toList(),
    );
  }
}
