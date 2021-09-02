import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/widgets/user_recommendation.dart';
import 'package:get/get.dart';

class Recommendation extends StatelessWidget {
  final RecommendationController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Get.parameters['threatTitle'].toString()),
          bottom: TabBar(
            tabs: <Widget>[
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserRecommendation(
              controller: controller,
            ),
            Center(
              child: Text(Get.parameters['recommendations'].toString()),
            )
          ],
        ),
      ),
    );
  }
}

//purely getx
