import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/model/recommendation.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';

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
      child: GFAccordion(
          expandedTitleBackgroundColor: Colors.white,
          titleChild: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: recommendation.implemented
                    ? Checkbox(
                        fillColor: MaterialStateProperty.all(Colors.green),
                        onChanged: null,
                        value: recommendation.implemented,
                      )
                    : Flexible(
                        child: Text(
                          recommendation.shortDescription,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
              ),
              Container(
                child: recommendation.implemented
                    ? Flexible(
                        child: Text(
                          recommendation.shortDescription,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      )
                    : SizedBox(),
              ),
              Text(
                _checkWeight(recommendation.weight!),
                style:
                    TextStyle(color: _showWeightColor(recommendation.weight!)),
              ),
            ],
          ),
          contentChild: Column(
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
          collapsedIcon: Icon(Icons.keyboard_arrow_down_sharp),
          expandedIcon: Icon(Icons.keyboard_arrow_up_sharp)),
    );
  }

  Widget _buildGetToolButton(
      Recommendation r, void Function()? onPressedGetTool) {
    if (!r.implemented) {
      return ElevatedButton(
          child: new Text("Get Tool"), onPressed: onPressedGetTool);
    } else {
      return Container();
    }
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
