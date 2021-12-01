import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
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
