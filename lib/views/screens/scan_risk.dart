import 'package:flutter/material.dart';
import 'package:geiger_toolbox/views/widgets/circular_button.dart';
import 'package:geiger_toolbox/views/widgets/side_menu.dart';
import 'package:geiger_toolbox/views/widgets/threats_card.dart';
import 'package:get/get.dart';
import 'package:geiger_toolbox/util/geiger_icon_icons.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ScanRiskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenuBar(),
      appBar: AppBar(
        title: Text('Geiger Toolbox'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Column(
              children: [
                topScreen(),
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
                SizedBox(height: 10.0),
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
                SizedBox(height: 2.0),
                ThreatsCard(
                  label: 'Phishing',
                  icon: GeigerIcon.phishing,
                  indicatorScore: 44.0,
                  routeName:
                      '/recommendationScreen/userId?threatTitle=Phishing',
                ),
                ThreatsCard(
                  label: 'Malware',
                  icon: GeigerIcon.malware,
                  indicatorScore: 44.0,
                  routeName: '/recommendationScreen/userId?threatTitle=Malware',
                ),
                ThreatsCard(
                  label: 'Web Attacks',
                  icon: GeigerIcon.webattacks,
                  indicatorScore: 88.0,
                  routeName:
                      '/recommendationScreen/userId?threatTitle=Web Attack',
                ),
                ThreatsCard(
                  label: 'Spam',
                  icon: GeigerIcon.spam,
                  indicatorScore: 100.0,
                  routeName: '/recommendationScreen/userId?threatTitle=Spam',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget topScreen() {
  return Center(
    child: Column(
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
      ],
    ),
  );
}
