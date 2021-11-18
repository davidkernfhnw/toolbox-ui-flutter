import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.fieldBuilderName,
    required this.defaultValue,
    required this.label,
    required this.hintText,
    Key? key,
  }) : super(key: key);

  final String fieldBuilderName;
  final String label;
  final String hintText;
  final String defaultValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        FormBuilderTextField(
          initialValue: defaultValue,
          name: fieldBuilderName,
          maxLength: 50,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              hintText: hintText,
              fillColor: Colors.white70),
        ),
      ],
    );
  }
}

class CustomTextFieldFlutter extends StatelessWidget {
  const CustomTextFieldFlutter(
      {Key? key,
      required this.label,
      required this.hintText,
      this.onChanged,
      required this.textEditingController})
      : super(key: key);

  final String label;
  final String hintText;
  final void Function(String? language)? onChanged;
  final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: textEditingController,
          onChanged: onChanged,
          maxLength: 50,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              hintText: hintText,
              fillColor: Colors.white70),
        ),
      ],
    );
  }
}
