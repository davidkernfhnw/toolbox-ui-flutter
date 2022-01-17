import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/device_recommendation.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/user_recommendation.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/widgets/tab_bar_builder.dart';
import 'package:geiger_toolbox/app/shared_widgets/showCircularProgress.dart';
import 'package:get/get.dart';

class RecommendationPage extends StatelessWidget {
  RecommendationPage({Key? key}) : super(key: key);

  //initialize recommendationController
  final RecommendationController controller =
      RecommendationController.instance();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(controller.userThreatScore.value.threat.name),
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
            body: controller.isLoading.value == false
                ? TabBarView(
                    children: [
                      UserRecommendation(controller: controller),
                      DeviceRecommendation(controller: controller)
                    ],
                  )
                : Center(child: ShowCircularProgress(visible: true))),
      );
    });
  }
}

//purely getx
