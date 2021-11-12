import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.fieldBuilderName,
    required this.label,
    required this.hintText,
    Key? key,
  }) : super(key: key);

  final String fieldBuilderName;
  final String label;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        FormBuilderTextField(
          name: fieldBuilderName,
          maxLength: 100,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: hintText,
              fillColor: Colors.white70),
        ),
      ],
    );
  }
}
