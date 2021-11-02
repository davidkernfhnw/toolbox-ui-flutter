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
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            TopScreen(
              onScanPressed: () {
                //testing Geiger Aggregate score Model

                controller.setGeigerAggregateThreatScore();
              },
              isLoading: false,
              aggregratedScore: '',
              warming: false,
            ),
          ])),
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
