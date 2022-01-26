import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/shared_widgets/indicator_gauge.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({Key? key, required this.device}) : super(key: key);
  final Icon device;
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              device,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText("Samsung Galaxy s8"),
                  greyText("Up to date: 17.03.21")
                ],
              ),
              Column(
                children: [
                  IndicatorGauge(
                    score: 40,
                  ),
                  ElevatedButton.icon(
                    onPressed: null,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    icon: Icon(Icons.delete),
                    label: Text("Remove"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
