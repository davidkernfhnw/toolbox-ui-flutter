import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/model/threat_score.dart';
import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:geiger_toolbox/app/modules/home/views/widgets/threats_card.dart';
import 'package:geiger_toolbox/app/modules/home/views/widgets/top_screen.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/shared_widgets/showCircularProgress.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:geiger_toolbox/app/util/geiger_icons.dart';
import 'package:get/get.dart';

import '../../settings/controllers/data_protection_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  // getting an instance of HomeController
  final HomeController controller = HomeController.instance;

  final DataProtectionController _dataProtectionController =
      DataProtectionController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("geiger-toolbox".tr),
      ),
      body: Obx(
        () {
          return controller.isLoadingServices.value == true
              ? Center(
                  child: ShowCircularProgress(
                      visible: controller.isLoadingServices.value,
                      message: controller.message.value),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TopScreen(
                        controller: controller,
                      ),
                      controller.aggThreatsScore.value.threatScores.isEmpty
                          ? const Center(
                              child: Text(
                                "NO DATA FOUND",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : Column(
                              children: controller
                                  .aggThreatsScore.value.threatScores
                                  .map<ThreatsCard>(
                                (ThreatScore t) {
                                  return ThreatsCard(
                                    label: t.threat.name,
                                    icon: GeigerIcon
                                        .iconsMap[t.threat.name.toLowerCase()],
                                    indicatorScore:
                                        double.parse(t.score.toString()),
                                    onpressed:
                                        _dataProtectionController.getDataAccess
                                            ? () => Get.toNamed(
                                                Routes.RECOMMENDATION_VIEW,
                                                arguments: t.threat)
                                            : null,
                                  );
                                },
                              ).toList(),
                            ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
