import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/compare/controller/compare_risk_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:geiger_toolbox/app/util/style.dart';

class CompareRiskPage extends StatelessWidget {
  CompareRiskPage({Key? key}) : super(key: key);
  final CompareRiskController controller = CompareRiskController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            boldText("Your Business "),
            Expanded(
              child: charts.BarChart(
                controller.seriesData,
                //defaultRenderer: charts.BarLaneRendererConfig(),
                animate: true,
                barGroupingType: charts.BarGroupingType.groupedStacked,
                //behaviors: [charts.SeriesLegend()],
                // animationDuration: Duration(seconds: 1),
                behaviors: [
                  charts.DatumLegend(
                    outsideJustification:
                        charts.OutsideJustification.endDrawArea,
                    horizontalFirst: false,
                    desiredMaxRows: 2,
                    showMeasures: true,
                    cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                    entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.purple.shadeDefault,
                        fontFamily: 'Georgia',
                        fontSize: 11),
                  )
                ],
              ),
            ),
            boldText("History of your Total Score"),
            Expanded(
              child: charts.LineChart(controller.seriesLineData,
                  animate: true,
                  behaviors: [
                    new charts.ChartTitle('Months',
                        behaviorPosition: charts.BehaviorPosition.bottom,
                        titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),
                    new charts.ChartTitle('Score',
                        behaviorPosition: charts.BehaviorPosition.start,
                        titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),
                    new charts.ChartTitle(
                      'Threat Level',
                      behaviorPosition: charts.BehaviorPosition.end,
                      titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea,
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
