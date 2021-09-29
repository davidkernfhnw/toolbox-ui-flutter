import 'package:geiger_toolbox/app/data/model/threat.dart';
import 'package:geiger_toolbox/app/modules/compare/bindings/compare_risk_binding.dart';
import 'package:geiger_toolbox/app/modules/compare/views/compare_risk_page.dart';
import 'package:geiger_toolbox/app/modules/home/views/home_page.dart';
import 'package:geiger_toolbox/app/modules/recommendation/binding/recommendation_binding.dart';
import 'package:geiger_toolbox/app/modules/home/bindings/home_binding.dart';
import 'package:geiger_toolbox/app/modules/recommendation/controller/recommendation_controller.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/recommendation_page.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class Pages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.HOME_PAGE,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.COMPARE_RISK_PAGE,
      page: () => CompareRiskPage(),
      binding: CompareRiskBinding(),
    ),
    GetPage(
      // /:variable
      name: Routes.RECOMMENDATION_PAGE,
      page: () => RecommendationPage(),
      binding: RecommendationBinding(),
    )
  ];
}
