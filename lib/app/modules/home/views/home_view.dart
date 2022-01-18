import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/threat_score.dart';
import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:geiger_toolbox/app/modules/home/views/widgets/threats_card.dart';
import 'package:geiger_toolbox/app/modules/home/views/widgets/top_screen.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/shared_widgets/showCircularProgress.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:geiger_toolbox/app/util/geiger_icons.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  // getting an instance of HomeController
  final HomeController controller = HomeController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Obx(() {
        return controller.isLoadingServices.value == true
            ? Visibility(
                maintainSize: true,
                maintainState: true,
                visible: true,
                child: SizedBox(),
              )
            : const SideMenu();
      }),
      appBar: AppBar(
        title: const Text('Geiger Toolbox'),
      ),
      body: Obx(
        () {
          //convert to geiger_score aggregate to double
          double a = double.parse(controller.aggThreatsScore.value.geigerScore);
          //back to String with precision
          String agg = a.toPrecision(1).toString();

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
                        onScanPressed: () {
                          //controller.emptyThreatScores();
                          controller.onScanButtonPressed();
                        },
                        aggregratedScore: !controller.isScanning.value
                            ? agg == "0.0"
                                ? ""
                                : agg
                            : "",
                        warming: false,
                        isLoading: controller.isScanning.value,
                      ),
                      controller.isScanning.value
                          ? ShowCircularProgress(
                              visible: controller.isScanning.value)
                          : controller
                                  .aggThreatsScore.value.threatScores.isEmpty
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
                                        icon: GeigerIcon.iconsMap[
                                            t.threat.name.toLowerCase()],
                                        indicatorScore:
                                            double.parse(t.score.toString()),
                                        routeName: Routes.RECOMMENDATION_VIEW,
                                        routeArguments: t.threat,
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
//with STACK
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     drawer: const SideMenu(),
//     appBar: AppBar(
//       title: const Text('Geiger Toolbox'),
//     ),
//     body: SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//       child: Obx(
//             () {
//           return Stack(
//             children: [
//               controller.isLoadingServices.value == true
//                   ? Positioned(
//                 child: Center(
//                   child: ShowCircularProgress(
//                       visible: controller.isLoadingServices.value,
//                       message: controller.message.value),
//                 ),
//               )
//                   : SizedBox(),
//               Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   TopScreen(
//                     onScanPressed: () {
//                       //controller.emptyThreatScores();
//                       controller.onScanButtonPressed();
//                     },
//                     aggregratedScore: !controller.isScanning.value
//                         ? controller.aggThreatsScore.value.geigerScore
//                         : "",
//                     warming: false,
//                     isLoading: controller.isScanning.value,
//                   ),
//                   controller.isScanning.value
//                       ? ShowCircularProgress(
//                       visible: controller.isScanning.value)
//                       : controller.aggThreatsScore.value.threatScores.isEmpty
//                       ? const Center(
//                     child: Text(
//                       "NO DATA FOUND",
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   )
//                       : Column(
//                     children: controller
//                         .aggThreatsScore.value.threatScores
//                         .map<ThreatsCard>((dummy.ThreatScore t) {
//                       return ThreatsCard(
//                         label: t.threat.name,
//                         icon: GeigerIcon
//                             .iconsMap[t.threat.name.toLowerCase()],
//                         indicatorScore:
//                         double.parse(t.score.toString()),
//                         routeName: Routes.RECOMMENDATION_VIEW,
//                         routeArguments: t.threat,
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     ),
//   );
// }
//

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
