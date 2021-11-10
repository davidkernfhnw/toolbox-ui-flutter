import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomDropDown extends StatelessWidget {
  CustomDropDown(
      {required this.fieldBuilderName,
      this.titleText,
      required this.listItems,
      required this.hintText,
      Key? key})
      : super(key: key);

  final String fieldBuilderName;
  final String? titleText;
  final List<String> listItems;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      /// focusNode issue : used after dispose

      name: fieldBuilderName,
      decoration: InputDecoration(
        labelText: titleText,
      ),
      // initialValue: 'Male',
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
