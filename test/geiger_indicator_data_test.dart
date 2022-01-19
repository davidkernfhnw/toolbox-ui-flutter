import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_indicator_data.dart';

void main() {
  final StorageController storageController =
      GenericController("test", DummyMapper("testdb"));

  final GeigerIndicatorHelper _global =
      GeigerIndicatorHelper(storageController);

  //final dummy.ThreatNode _geigerDummy = dummy.ThreatNode(storageController);
  group("test GlobalThreat", () {
    // setUp(() async {
    //   await _geigerDummy.setGlobalThreatsNode(threats: [
    //     dummy.Threat(name: "phishing"),
    //     dummy.Threat(name: "malware"),
    //     dummy.Threat(name: "attack")
    //   ]);
    // });
    test("test Global threat parser", () async {
      var g = await _global.getGlobalThreats();
      // ignore: avoid_print
      print("${g}");
    });

    test("test limited Global threat parser", () async {
      var g = await _global.getLimitedThreats();
      // ignore: avoid_print
      print("Limit Threat List: ${g}");
    });
  });
}
