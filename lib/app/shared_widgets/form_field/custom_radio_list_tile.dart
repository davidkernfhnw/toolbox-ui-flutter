import 'package:flutter/material.dart';

class CustomLabeledRadio extends StatelessWidget {
  CustomLabeledRadio(
      {Key? key,
      required this.label,
      this.description,
      required this.padding,
      required this.groupValue,
      required this.value,
      required this.onChanged})
      : super(key: key);

  final String label;
  final String? description;
  final EdgeInsets padding;
  final int groupValue;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label),
                  description != null ? Text(description ?? "") : Container(),
                ],
              ),
            ),
            Radio<int>(
              groupValue: groupValue,
              value: value,
              onChanged: (int? newValue) {
                onChanged(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
