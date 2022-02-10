import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/model/professional_association.dart';

class CustomDropDownProfAss extends StatelessWidget {
  const CustomDropDownProfAss(
      {Key? key,
      this.titleText,
      required this.certs,
      required this.hintText,
      this.onChanged,
      this.defaultValue})
      : super(key: key);

  final String? titleText;
  final List<ProfessionalAssociation> certs;
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
      items: certs
          .map((ProfessionalAssociation item) => DropdownMenuItem(
                value: item.name,
                child: Text('${item.name}'),
              ))
          .toList(),
    );
  }
}
