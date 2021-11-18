import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PartnersDropDown extends StatelessWidget {
  PartnersDropDown(
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
  final List listItems;
  final String hintText;
  final String? defaultValue;
  final void Function(dynamic partner)? onChanged;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      /// focusNode issue : used after dispose

      name: fieldBuilderName,
      decoration: InputDecoration(
        labelText: titleText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      initialValue: defaultValue,
      onChanged: onChanged,
      allowClear: true,
      hint: Text(hintText),

      items: listItems
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text('$item'),
              ))
          .toList(),
    );
  }
}
