import 'package:geiger_toolbox/bindings/compare_risk_binding.dart';
import 'package:geiger_toolbox/bindings/recommendation_binding.dart';
import 'package:geiger_toolbox/bindings/scan_risk_binding.dart';
import 'package:geiger_toolbox/views/screens/compare_risk.dart';
import 'package:geiger_toolbox/views/screens/recommendation.dart';
import 'package:geiger_toolbox/views/screens/scan_risk.dart';
import 'package:get/get.dart';

class Routes {
  static final List<GetPage> screens = [
    GetPage(
      name: '/scanRiskScreen',
      page: () => ScanRiskScreen(),
      binding: ScanRiskBinding(),
    ),
    GetPage(
      name: '/compareRiskScreen',
      page: () => CompareRisk(),
      binding: CompareRiskBinding(),
    ),
    GetPage(
      name: '/recommendationScreen/:recommendations',
      page: () => Recommendation(),
      binding: RecommendationBinding(),
    )
  ];
}
