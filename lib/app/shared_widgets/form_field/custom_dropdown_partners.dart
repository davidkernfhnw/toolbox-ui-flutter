import 'package:flutter/material.dart';

class CustomDropDownFlutter extends StatelessWidget {
  const CustomDropDownFlutter(
      {Key? key,
      this.titleText,
      required this.listItems,
      required this.hintText,
      this.onChanged,
      this.defaultValue})
      : super(key: key);

  final String? titleText;
  final List listItems;
  final String hintText;
  final String? defaultValue;
  final void Function(dynamic partner)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: defaultValue,
      decoration: InputDecoration(
        labelText: titleText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
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
