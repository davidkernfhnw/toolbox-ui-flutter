import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class QrScannerCard extends StatelessWidget {
  QrScannerCard(
      {Key? key,
      required this.title,
      required this.msgBody,
      required this.btnIcon,
      required this.btnText,
      this.onScan})
      : super(key: key);

  final String title;
  final String msgBody;
  final void Function()? onScan;
  final Icon btnIcon;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            boldText(
              title,
            ),
            greyText(
              msgBody,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: onScan ?? null,
                    icon: btnIcon,
                    label: Text(btnText))
              ],
            )
          ],
        ),
      ),
    );
  }
}
