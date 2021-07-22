import 'package:flutter/material.dart';
import 'package:geiger_toolbox/controllers/scan_risk_controller.dart';
import 'package:geiger_toolbox/model/threats_model.dart';
import 'package:geiger_toolbox/routes/pages.dart';
import 'package:geiger_toolbox/routes/routes.dart';
import 'package:geiger_toolbox/views/widgets/circular_button.dart';
import 'package:geiger_toolbox/views/widgets/side_menu.dart';
import 'package:geiger_toolbox/views/widgets/threats_card.dart';
import 'package:geiger_toolbox/views/widgets/topScreen.dart';
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Column(
            children: [
              TopScreen(),
              Column(
                children:
                    controller.threatList.map<ThreatsCard>((ThreatsModel e) {
                  return ThreatsCard(
                      label: e.title,
                      icon: GeigerIcon.iconsMap[e.title!.toLowerCase()],
                      indicatorScore: double.parse(e.score.toString()),
                      routeName: Routes.RECOMMENDATION +
                          '/userId?threatTitle=${e.title}');
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
