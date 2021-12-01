import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/compare/controller/compare_risk_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';

class CompareRiskPage extends StatelessWidget {
  CompareRiskPage({Key? key}) : super(key: key);
  final CompareRiskController controller = CompareRiskController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
      ),
      drawer: const SideMenu(),
      body: Center(
        child: Text(controller.title),
      ),
    );
  }
}
