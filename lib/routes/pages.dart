import 'package:geiger_toolbox/bindings/compare_risk_binding.dart';
import 'package:geiger_toolbox/bindings/recommendation_binding.dart';
import 'package:geiger_toolbox/bindings/scan_risk_binding.dart';
import 'package:geiger_toolbox/routes/routes.dart';
import 'package:geiger_toolbox/views/screens/compare_risk.dart';
import 'package:geiger_toolbox/views/screens/recommendation.dart';
import 'package:geiger_toolbox/views/screens/scan_risk.dart';
import 'package:get/get.dart';

class Pages {
  static final List<GetPage> screens = [
    GetPage(
      name: Routes.SCAN_RISK,
      page: () => ScanRiskScreen(),
      binding: ScanRiskBinding(),
    ),
    GetPage(
      name: Routes.COMPARE_RISK,
      page: () => CompareRisk(),
      binding: CompareRiskBinding(),
    ),
    GetPage(
      // /:variable
      name: Routes.RECOMMENDATION + '/:recommendations',
      page: () => Recommendation(),
      binding: RecommendationBinding(),
    )
  ];
}
