import 'package:flutter/material.dart';
import 'package:geiger_toolbox/views/widgets/indicator_guage.dart';
import 'package:get/get.dart';

class Recommendation extends StatelessWidget {
  const Recommendation({Key? key}) : super(key: key);

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
            Center(
              child: Text(Get.parameters['recommendations'].toString()),
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
