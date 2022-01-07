import 'package:flutter_test/flutter_test.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_indicator_data.dart';

void main() {
  final StorageController storageController =
      GenericController("test", DummyMapper("testdb"));

  final GeigerIndicatorData _global = GeigerIndicatorData(storageController);

  test("test Global threat parser", () {});
}
