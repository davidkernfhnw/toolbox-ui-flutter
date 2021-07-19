import 'package:flutter/material.dart';
import 'package:geiger_toolbox/views/widgets/side_menu.dart';
import 'package:geiger_toolbox/controllers/compare_risk_controller.dart';
import 'package:get/get.dart';

class CompareRisk extends StatelessWidget {
  final CompareRiskController controller = Get.find<CompareRiskController>();
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
