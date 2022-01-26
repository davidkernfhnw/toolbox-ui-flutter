import 'dart:developer';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompareRiskController extends GetxController {
  //an instance of CompareRiskController
  static CompareRiskController get to => Get.find();

  final title = 'CompareRisk screen';
  late List<charts.Series<Record, String>> seriesData;
  late List<charts.Series<TimeRecord, int>> seriesLineData;
  void _generateData() {
    List<Record> barData1 = [
      Record(10, "Phishing", Color(0xff3366cc)),
      Record(30, "Malware", Color(0xff990099)),
      Record(100, "Web-based attacks", Color(0xff109618))
    ];

    // List<Record> data2 = [
    //   Record(40, "Phishing", Color(0xff3366cc)),
    //   Record(10, "Malware", Color(0xff990099)),
    //   Record(70, "Web-based attacks", Color(0xff109618))
    // ];
    // List<Record> data3 = [
    //   Record(100, "Phishing", Color(0xff3366cc)),
    //   Record(60, "Malware", Color(0xff990099)),
    //   Record(40, "Web-based attacks", Color(0xff109618))
    // ];
    List<TimeRecord> _linesData = [
      TimeRecord(40, DateTime(2020, 1)),
      TimeRecord(50, DateTime(2020, 2)),
      TimeRecord(100, DateTime(2020, 3)),
    ];

    seriesData.add(charts.Series(
      domainFn: (Record record, _) => record.threat,
      measureFn: (Record record, _) => record.percentage,
      id: "1",
      data: barData1,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (Record record, _) =>
          charts.ColorUtil.fromDartColor(record.colorVal),
    ));

    // seriesData.add(charts.Series(
    //   domainFn: (Record record, _) => record.threat,
    //   measureFn: (Record record, _) => record.percentage,
    //   id: "2",
    //   data: data2,
    //   fillPatternFn: (_, __) => charts.FillPatternType.solid,
    //   colorFn: (Record record, _) =>
    //       charts.ColorUtil.fromDartColor(record.colorVal),
    // ));
    //
    // seriesData.add(charts.Series(
    //   domainFn: (Record record, _) => record.threat,
    //   measureFn: (Record record, _) => record.percentage,
    //   id: "3",
    //   data: data3,
    //   fillPatternFn: (_, __) => charts.FillPatternType.solid,
    //   colorFn: (Record record, _) =>
    //       charts.ColorUtil.fromDartColor(record.colorVal),
    // ));
    seriesLineData.add(charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'line data',
        data: _linesData,
        domainFn: (TimeRecord timeRecord, _) => timeRecord.monthsVal.month,
        measureFn: (TimeRecord timeRecord, _) => timeRecord.percentage));
  }

  @override
  void onInit() {
    seriesData = <charts.Series<Record, String>>[];
    seriesLineData = <charts.Series<TimeRecord, int>>[];
    _generateData();
    super.onInit();
  }

  @override
  void onReady() {
    log('>>> compareRiskController ready');
    super.onReady();
  }

  @override
  void onClose() {
    log('>>> compareRiskController close');
    super.onClose();
  }
}

class Task {
  String task;
  double taskValue;
  Color colorVal;

  Task(this.task, this.taskValue, this.colorVal);
}

class Record {
  int percentage;
  String threat;
  Color colorVal;
  Record(this.percentage, this.threat, this.colorVal);
}

class TimeRecord {
  int percentage;
  DateTime monthsVal;
  TimeRecord(this.percentage, this.monthsVal);
}
