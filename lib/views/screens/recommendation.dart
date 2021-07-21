import 'package:flutter/material.dart';
import 'package:geiger_toolbox/controllers/recommendation_controller.dart';
import 'package:geiger_toolbox/model/recommendations_models.dart';
import 'package:geiger_toolbox/views/widgets/indicator_guage.dart';
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
/*class UserRecommendation extends StatelessWidget {
  RecommendationController? controller;
  UserRecommendation({this.controller});

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
            Obx(
              () {
                return ExpansionPanelList(
                  expansionCallback: (index, isOpen) {
                    controller!.isExpanding(index, isOpen);
                  },
                  // animationDuration: Duration(seconds: 2),
                  children: controller!.recommendations
                      .map<ExpansionPanel>((RecommendationModel e) {
                    return ExpansionPanel(
                        headerBuilder: (context, isOpen) {
                          return ListTile(
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
                          );
                        },
                        body: Padding(
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
                        isExpanded: controller!.press.value);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}*/

//getx and stateful
class UserRecommendation extends StatefulWidget {
  RecommendationController? controller;
  UserRecommendation({this.controller});
  @override
  _UserRecommendationState createState() => _UserRecommendationState();
}

class _UserRecommendationState extends State<UserRecommendation> {
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
            ExpansionPanelList(
              expansionCallback: (index, isOpen) {
                setState(() {
                  widget.controller!.recommendations[index].isExpanded =
                      !isOpen;
                });
              },
              // animationDuration: Duration(seconds: 2),
              children: widget.controller!.recommendations
                  .map<ExpansionPanel>((RecommendationModel e) {
                return ExpansionPanel(
                    headerBuilder: (context, isOpen) {
                      return ListTile(
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
                      );
                    },
                    body: Padding(
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
                    isExpanded: e.isExpanded);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
