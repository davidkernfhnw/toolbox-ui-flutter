import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class ShowCircularProgress extends StatelessWidget {
  const ShowCircularProgress({Key? key, required this.visible, this.message})
      : super(key: key);
  final bool visible;
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: visible,
      child: Container(
        margin: EdgeInsets.only(top: 50, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator.adaptive(
              backgroundColor: Colors.green,
            ),
            boldText(message ?? ""),
          ],
        ),
      ),
    );
  }
}
