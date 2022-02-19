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

  static buildShowDialog(BuildContext context,
      {String message: "Replicating...",
      bool visible: true,
      Color color: Colors.white}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: visible,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green,
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        });
  }
}
