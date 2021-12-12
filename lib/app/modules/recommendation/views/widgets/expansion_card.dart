import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/recommendations_models.dart';
import 'package:geiger_dummy_data/geiger_dummy_data.dart' as dummy;

class ExpansionCard extends StatelessWidget {
  final dummy.Recommendations recommendationData;
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
            recommendationData.description.shortDescription,
            softWrap: true,
            style: const TextStyle(),
          ),
          trailing: const Text("high"),
        ),
        collapsed: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recommendationData.description.longDescription!,
                softWrap: true,
              ),
              const SizedBox(height: 5),
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
}
