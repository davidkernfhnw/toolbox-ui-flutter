import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:geiger_toolbox/app/modules/compare/controller/compare_risk_controller.dart';

import 'package:get/get.dart';

class CompareRiskPage extends StatelessWidget {
  final CompareRiskController controller = CompareRiskController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
      ),
      drawer: SideMenuBar(),
      body: Center(
        child: Text(controller.title),
      ),
    );
  }
}
