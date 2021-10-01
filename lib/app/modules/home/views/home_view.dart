import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/threat.dart';

import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:geiger_toolbox/app/modules/home/views/widgets/threats_card.dart';
import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:geiger_toolbox/app/modules/home/views/widgets/top_screen.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/util/geiger_icons.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  // getting an instance of HomeController
  final HomeController controller = HomeController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenuBar(),
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
                  controller.setGeigerAggregateThreatScore();
                  log(controller.setGeigerAggregateThreatScore().toString());
                },
                aggregratedScore: !controller.isLoading.value
                    ? controller.geigerAggregateScore.value.geigerScore ?? ""
                    : "",
                warming: false,
                isLoading: controller.isLoading.value,
              ),
              controller.isLoading.value
                  ? const CircularProgressIndicator.adaptive()
                  : controller.threatsScore.isEmpty
                      ? const Center(
                          child: Text("NO DATA FOUND"),
                        )
                      : Column(
                          children: controller.threatsScore
                              .map<ThreatsCard>((Threat e) {
                            return ThreatsCard(
                              label: e.name,
                              icon: GeigerIcon.iconsMap[e.name!.toLowerCase()],
                              indicatorScore:
                                  double.parse(e.score!.score.toString()),
                              routeName: Routes.RECOMMENDATION_VIEW,
                              routeArguments: e,
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
controller.getGeigerAggregateThreatScore().length,
itemBuilder: (BuildContext context, int index) =>
ThreatsCard(
label: controller
    .getGeigerAggregateThreatScore()[index]
.name,
icon: GeigerIcon.iconsMap[controller
    .getGeigerAggregateThreatScore()[index]
.name
    .toLowerCase()],
indicatorScore: double.parse(controller
    .getGeigerAggregateThreatScore()[index]
.score
    .score
    .toString()),
routeName: Routes.RECOMMENDATION_PAGE +
'/userId?threatTitle=${controller.getGeigerAggregateThreatScore()[index].name}',
),
),*/
