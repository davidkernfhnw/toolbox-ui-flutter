import 'package:flutter/material.dart';

Widget boldText(String text) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold),
  );
}

Widget greyText(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.grey),
  );
}

Padding buildPaddedText(String text) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: SizedBox(
      width: 500,
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
