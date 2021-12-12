import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;
import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:geiger_toolbox/app/modules/home/views/widgets/threats_card.dart';
import 'package:geiger_toolbox/app/modules/home/views/widgets/top_screen.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:geiger_toolbox/app/util/geiger_icons.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  // getting an instance of HomeController
  final HomeController controller = HomeController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text('Geiger Toolbox'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TopScreen(
                onScanPressed: () {
                  //testing Geiger Aggregate score Model
                  controller.emptyThreatScores();
                  controller.onScanSetGeigerAgg();
                  log(controller.onScanSetGeigerAgg().toString());
                },
                aggregratedScore: !controller.isLoading.value
                    ? controller.aggThreatsScore.value.geigerScore
                    : "",
                warming: false,
                isLoading: controller.isLoading.value,
              ),
              controller.isLoading.value
                  ? const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.green,
                    )
                  : controller.aggThreatsScore.value.threatScores.isEmpty
                      ? const Center(
                          child: Text("NO DATA FOUND"),
                        )
                      : Column(
                          children: controller
                              .aggThreatsScore.value.threatScores
                              .map<ThreatsCard>((dummy.ThreatScore e) {
                            return ThreatsCard(
                              label: e.threat.name,
                              icon: GeigerIcon
                                  .iconsMap[e.threat.name.toLowerCase()],
                              indicatorScore: double.parse(e.score.toString()),
                              routeName: Routes.RECOMMENDATION_VIEW,
                              routeArguments: e.threat,
                            );
                          }).toList(),
                        ),
            ],
          );
        }),
      ),
    );
  }
}

//ListView.builder //

/*
ListView.builder(
shrinkWrap: true,
itemCount:
controllers.getGeigerAggregateThreatScore().length,
itemBuilder: (BuildContext context, int index) =>
ThreatsCard(
label: controllers
    .getGeigerAggregateThreatScore()[index]
.name,
icon: GeigerIcon.iconsMap[controllers
    .getGeigerAggregateThreatScore()[index]
.name
    .toLowerCase()],
indicatorScore: double.parse(controllers
    .getGeigerAggregateThreatScore()[index]
.score
    .score
    .toString()),
routeName: Routes.RECOMMENDATION_PAGE +
'/userId?threatTitle=${controllers.getGeigerAggregateThreatScore()[index].name}',
),
),*/
