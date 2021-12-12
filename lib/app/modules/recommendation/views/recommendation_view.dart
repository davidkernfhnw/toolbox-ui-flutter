import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/device_recommendation.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/widgets/tab_bar_builder.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/user_recommendation.dart';
import 'package:get/get.dart';

class RecommendationPage extends StatelessWidget {
  RecommendationPage({Key? key}) : super(key: key);

  //initialize recommendationController
  final RecommendationController controller = RecommendationController.to();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text(controller.userThreatScore.value.threat.name);
          }),
          bottom: buildTabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.person,
              ),
              text: "User",
            ),
            Tab(
              icon: Icon(
                Icons.phone_android_rounded,
              ),
              text: "Device Risk",
            ),
          ]),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            UserRecommendation(controller: controller),
            DeviceRecommendation(controller: controller)
          ],
        ),
      ),
    );
  }
}

//purely getx
