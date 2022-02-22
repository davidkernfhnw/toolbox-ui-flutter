import 'package:flutter/material.dart';

import '../../model/country.dart';

class CustomDropDownCountry extends StatelessWidget {
  const CustomDropDownCountry(
      {Key? key,
      this.titleText,
      required this.countries,
      required this.hintText,
      this.defaultValue,
      this.onChanged})
      : super(key: key);

  final String? titleText;
  final List<Country> countries;
  final String hintText;
  final String? defaultValue;
  final void Function(dynamic country)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      /// focusNode issue : used after dispose
      value: defaultValue,
      decoration: InputDecoration(
        labelText: titleText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
      hint: Text(hintText),
      items: countries
          .map((Country item) => DropdownMenuItem(
                value: item.id,
                child: Text('${item.name}'),
              ))
          .toList(),
    );
  }
}
