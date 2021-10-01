import 'package:geiger_toolbox/app/modules/compare/bindings/compare_risk_binding.dart';
import 'package:geiger_toolbox/app/modules/compare/views/compare_risk_page.view';
import 'package:geiger_toolbox/app/modules/employee/bindings/employee_binding.dart';
import 'package:geiger_toolbox/app/modules/employee/views/employee_view.dart';
import 'package:geiger_toolbox/app/modules/home/views/home_view.dart';
import 'package:geiger_toolbox/app/modules/recommendation/binding/recommendation_binding.dart';
import 'package:geiger_toolbox/app/modules/home/bindings/home_binding.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/recommendation_page.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class Pages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.HOME_VIEW,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.COMPARE_RISK_VIEW,
      page: () => CompareRiskPage(),
      binding: CompareRiskBinding(),
    ),
    GetPage(
      name: Routes.RECOMMENDATION_VIEW,
      page: () => RecommendationPage(),
      binding: RecommendationBinding(),
    ),
    GetPage(
      name: Routes.EMPLOYEE_VIEW,
      page: () => EmployeeView(),
      binding: EmployeeBinding(),
    ),
  ];
}
