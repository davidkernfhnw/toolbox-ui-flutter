import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/role.dart';
import 'package:geiger_toolbox/app/data/model/threats_model.dart';
import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:geiger_toolbox/app/modules/home/views/widgets/threats_card.dart';
import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:geiger_toolbox/app/modules/home/views/widgets/topScreen.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/util/geiger_icons.dart';

import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenuBar(),
      appBar: AppBar(
        title: Text('Geiger Toolbox'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Column(
            children: [
              TopScreen(
                onScanPressed: () {
                  User user = User(
                    userId: "12345",
                    role: Role(id: "12345", name: "testing2"),
                  );

                  print(user.toJson());
                },
                aggregratedScore: '77',
                warming: false,
              ),
              Column(
                children:
                    controller.threatList.map<ThreatsCard>((ThreatsModel e) {
                  return ThreatsCard(
                      label: e.title,
                      icon: GeigerIcon.iconsMap[e.title!.toLowerCase()],
                      indicatorScore: double.parse(e.score.toString()),
                      routeName: Routes.RECOMMENDATION_PAGE +
                          '/userId?threatTitle=${e.title}');
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
