import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/recommendations_models.dart';

class ExpansionCard extends StatelessWidget {
  final RecommendationModel recommendationData;
  const ExpansionCard({Key? key, required this.recommendationData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpandablePanel(
        controller: ExpandableController(initialExpanded: true),
        header: ListTile(
          leading: Checkbox(
            onChanged: (bool? value) {},
            value: true,
          ),
          title: Text(
            recommendationData.header.toString(),
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
                recommendationData.body.toString(),
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
  }
}
