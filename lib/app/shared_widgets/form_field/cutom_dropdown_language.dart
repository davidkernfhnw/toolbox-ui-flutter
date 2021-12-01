import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/language.dart';

class CustomDropdownLanguage extends StatelessWidget {
  const CustomDropdownLanguage(
      {Key? key,
      this.titleText,
      required this.listItems,
      required this.hintText,
      this.defaultValue,
      this.onChanged})
      : super(key: key);

  final String? titleText;
  final List<Language> listItems;
  final String hintText;
  final String? defaultValue;
  final void Function(String? language)? onChanged;
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
          .map((Language item) => DropdownMenuItem(
                value: item.symbol,
                child: Text(item.language),
              ))
          .toList(),
    );
  }
}
