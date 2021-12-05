import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.label,
      required this.hintText,
      this.onChanged,
      //required this.textEditingController,
      this.initialValue,
      this.validator})
      : super(key: key);

  final String label;
  final String hintText;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  //final TextEditingController textEditingController;
  final String? initialValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(
          // controller: textEditingController,
          initialValue: initialValue,
          onChanged: onChanged,
          validator: validator,
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
