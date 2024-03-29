import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/shared_widgets/indicator_gauge.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class DeviceCard extends StatelessWidget {
  DeviceCard({Key? key, this.onPress}) : super(key: key);
  final void Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            boldText("This device:"),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.values[4],
              children: [
                Icon(Icons.phone_android),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText("Samsung Galaxy s8"),
                    greyText("Up to date: 17.03.21")
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IndicatorGauge(
                      score: 40,
                    ),
                    ElevatedButton.icon(
                        onPressed: onPress,
                        icon: Icon(Icons.qr_code_scanner),
                        label: Text("QR Code")),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
