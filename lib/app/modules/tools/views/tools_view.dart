import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/tools/controllers/tools_controller.dart';
import 'package:geiger_toolbox/app/modules/tools/views/widgets/tools_card.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:get/get.dart';

class ToolsView extends StatelessWidget {
  final ToolsController controller = ToolsController.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('tools'.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: controller.tools.length,
            itemBuilder: (BuildContext context, int index) => ToolCard(
              companyName: controller.tools[index].company,
              appName: controller.tools[index].appName,
              toolId: controller.tools[index].toolId,
              installed: controller.installed.value,
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        );
      }),
    );
  }
}
