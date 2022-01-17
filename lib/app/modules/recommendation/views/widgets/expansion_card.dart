import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/recommendation.dart';

class ExpansionCard extends StatelessWidget {
  final Recommendation recommendation;
  const ExpansionCard({Key? key, required this.recommendation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpandablePanel(
        controller: ExpandableController(initialExpanded: true),
        header: ListTile(
          leading: Checkbox(
            onChanged: (bool? value) {},
            value: false,
          ),
          title: Text(
            recommendation.shortDescription,
            softWrap: true,
            style: const TextStyle(),
          ),
          trailing: Text(
            checkWeight(recommendation.weight!),
            style: TextStyle(color: showWeightColor(recommendation.weight!)),
          ),
        ),
        collapsed: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                recommendation.longDescription!,
                softWrap: true,
              ),
              recommendation.longDescription == ""
                  ? const SizedBox(
                      height: 0,
                    )
                  : const SizedBox(height: 5),
              const Text(
                "Required Tool:",
                style: TextStyle(color: Colors.black45),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
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

  String checkWeight(String weight) {
    if (weight == '0.1') {
      return "Low";
    } else if (weight == '0.5') {
      return "Medium";
    } else {
      return "High";
    }
  }

  Color showWeightColor(String level) {
    String weight = checkWeight(level);
    if (weight == "Low") {
      return Colors.green;
    } else if (weight == "Medium") {
      return Colors.orangeAccent;
    } else {
      return Colors.red;
    }
  }
}
