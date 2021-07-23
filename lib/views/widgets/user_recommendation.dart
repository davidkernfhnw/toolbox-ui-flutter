import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geiger_toolbox/controllers/recommendation_controller.dart';
import 'package:geiger_toolbox/model/recommendations_models.dart';
import 'package:get/get.dart';
import 'indicator_guage.dart';

class UserRecommendation extends StatelessWidget {
  final RecommendationController? controller;
  const UserRecommendation({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            IndicatorGauge(score: 44),
            Text("Current user"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: null,
                  child: Row(
                    children: [
                      Icon(Icons.warning_rounded),
                      SizedBox(width: 5),
                      Text("About ${Get.parameters['threatTitle']}"),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: null,
                  child: Row(
                    children: [
                      Icon(Icons.warning_rounded),
                      SizedBox(width: 5),
                      Text("About Device"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Personal Recommendations"),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Obx(
              () {
                return Column(
                  // animationDuration: Duration(seconds: 2),
                  children: controller!.recommendations
                      .map<Widget>((RecommendationModel e) {
                    return Card(
                      child: ExpandablePanel(
                        controller: ExpandableController(initialExpanded: true),
                        header: ListTile(
                          leading: Checkbox(
                            onChanged: (bool? value) {},
                            value: true,
                          ),
                          title: Text(
                            e.header.toString(),
                            softWrap: true,
                            style: TextStyle(),
                          ),
                          trailing: Text("high"),
                        ),
                        collapsed: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.body.toString(),
                                softWrap: true,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Required Tool:",
                                style: TextStyle(color: Colors.black45),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: null,
                                    child: Text("Get Help"),
                                  ),
                                  SizedBox(width: 10),
                                  OutlinedButton(
                                    onPressed: null,
                                    child: Text("Get Tool"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        expanded: Container(),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
