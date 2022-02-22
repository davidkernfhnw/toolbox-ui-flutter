import 'package:flutter/material.dart';

import '../../model/cert.dart';

class CustomDropDownCert extends StatelessWidget {
  const CustomDropDownCert(
      {Key? key,
      this.titleText,
      required this.certs,
      required this.hintText,
      this.onChanged,
      this.defaultValue,
      this.validator})
      : super(key: key);

  final String? titleText;
  final List<Cert> certs;
  final String hintText;
  final String? defaultValue;
  final String? Function(String? value)? validator;
  final void Function(dynamic partner)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      validator: validator,
      value: defaultValue,
      decoration: InputDecoration(
        labelText: titleText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
      hint: Text(hintText),
      items: certs
          .map((Cert item) => DropdownMenuItem(
                value: item.name,
                child: Text('${item.name}'),
              ))
          .toList(),
    );
  }
}
