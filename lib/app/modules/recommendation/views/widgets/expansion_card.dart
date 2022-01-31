import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/data/model/recommendation.dart';

class ExpansionCard extends StatelessWidget {
  final Recommendation recommendation;
  final void Function()? onPressedGetTool;
  ExpansionCard({
    Key? key,
    required this.recommendation,
    required this.onPressedGetTool,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpandablePanel(
        controller: ExpandableController(initialExpanded: true),
        header: ListTile(
          leading: Checkbox(
            fillColor: MaterialStateProperty.all(Colors.green),
            onChanged: null,
            value: recommendation.implemented,
          ),
          title: Text(
            recommendation.shortDescription,
            softWrap: true,
            style: const TextStyle(),
          ),
          trailing: Text(
            _checkWeight(recommendation.weight!),
            style: TextStyle(color: _showWeightColor(recommendation.weight!)),
          ),
        ),
        collapsed: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              recommendation.longDescription == ""
                  ? Text(
                      // recommendation.longDescription!,
                      recommendation.recommendationId,
                      softWrap: true,
                    )
                  : Text(
                      // recommendation.longDescription!,
                      recommendation.longDescription!,
                      softWrap: true,
                    ),
              const Text(
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
                  _buildGetToolButton(recommendation, onPressedGetTool),
                ],
              ),
            ],
          ),
        ),
        expanded: Container(),
      ),
    );
  }

  Widget _buildGetToolButton(
      Recommendation r, void Function()? onPressedGetTool) {
    return new ElevatedButton(
        child: new Text(recommendation.implemented ? "Active" : "Get Tool"),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                recommendation.implemented ? Colors.grey : Colors.green)),
        onPressed: recommendation.implemented ? null : onPressedGetTool);
  }

  String _checkWeight(String weight) {
    if (weight == '0.1') {
      return "Low";
    } else if (weight == '0.5') {
      return "Medium";
    } else {
      return "High";
    }
  }

  Color _showWeightColor(String level) {
    String weight = _checkWeight(level);
    if (weight == "Low") {
      return Colors.green;
    } else if (weight == "Medium") {
      return Colors.orangeAccent;
    } else {
      return Colors.red;
    }
  }
}
