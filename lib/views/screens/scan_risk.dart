import 'package:flutter/material.dart';
import 'package:geiger_toolbox/controllers/scan_risk_controller.dart';
import 'package:geiger_toolbox/model/threats_model.dart';
import 'package:geiger_toolbox/views/widgets/circular_button.dart';
import 'package:geiger_toolbox/views/widgets/side_menu.dart';
import 'package:geiger_toolbox/views/widgets/threats_card.dart';
import 'package:get/get.dart';
import 'package:geiger_toolbox/util/geiger_icon_icons.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ScanRiskScreen extends StatelessWidget {
  final ScanRiskController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenuBar(),
      appBar: AppBar(
        title: Text('Geiger Toolbox'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Column(
          children: [
            Expanded(child: topScreen()),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.threatList.length,
                itemBuilder: (context, index) {
                  return ThreatsCard(
                      label: controller.threatList[index].title,
                      icon: GeigerIcon.iconsMap[
                          controller.threatList[index].title!.toLowerCase()],
                      indicatorScore: double.parse(
                          controller.threatList[index].score.toString()),
                      routeName:
                          '/recommendationScreen/userId?threatTitle=Web Attack');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*class TopScreen extends StatelessWidget {
  Widget? title;
  Widget? aggregratedWidget;
  String? aggregratedScore;
  Widget? centerWidget;
  List<OutlinedButton> outlinedButtons = [];
  List<Text> description = [];

  TopScreen(
      {Key? key,
      this.title,
      this.aggregratedWidget,
      this.aggregratedScore,
      this.centerWidget,
      required this.outlinedButtons,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title,
        SizedBox(height: 10.0),
        aggregratedWidget!,
        SizedBox(height: 10.0),
        centerWidget!,
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: outlinedButtons,
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: description,
        ),
      ],
    );
  }
}*/

Widget topScreen() {
  return Column(
    children: [
      Text(
        'Your total Risk Score:',
        style: TextStyle(color: Colors.grey),
      ),
      SizedBox(height: 10.0),
      GradientText(
        '70.25',
        style: TextStyle(
          fontSize: 34.0,
          fontWeight: FontWeight.w700,
        ),
        colors: [
          Color(0xffD92323),
          Color(0xffD92323),
        ],
      ),
      SizedBox(height: 10.0),
      CircularButton(),
      SizedBox(height: 20.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: null,
            child: Text(
              'Employee Scores',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          OutlinedButton(
            onPressed: null,
            autofocus: true,
            child: Text(
              'Device Scores',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
      SizedBox(height: 5.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Current Threats',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            'Threat Levels',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ],
  );
}
