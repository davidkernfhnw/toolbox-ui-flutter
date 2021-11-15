import 'package:get/get.dart';

import 'package:geiger_toolbox/app/modules/compare/bindings/compare_risk_binding.dart';
import 'package:geiger_toolbox/app/modules/compare/views/compare_risk_view.dart';
import 'package:geiger_toolbox/app/modules/device/bindings/device_binding.dart';
import 'package:geiger_toolbox/app/modules/device/views/device_view.dart';
import 'package:geiger_toolbox/app/modules/employee/bindings/employee_binding.dart';
import 'package:geiger_toolbox/app/modules/employee/views/employee_view.dart';
import 'package:geiger_toolbox/app/modules/home/bindings/home_binding.dart';
import 'package:geiger_toolbox/app/modules/home/views/home_view.dart';
import 'package:geiger_toolbox/app/modules/qrcode/bindings/qr_scanner_binding.dart';
import 'package:geiger_toolbox/app/modules/qrcode/views/qr_scanner_view.dart';
import 'package:geiger_toolbox/app/modules/recommendation/binding/recommendation_binding.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/recommendation_page.dart';
import 'package:geiger_toolbox/app/modules/settings/bindings/settings_binding.dart';
import 'package:geiger_toolbox/app/modules/settings/views/settings_view.dart';
import 'package:geiger_toolbox/app/modules/termsAndConditions/bindings/terms_and_conditions_binding.dart';
import 'package:geiger_toolbox/app/modules/termsAndConditions/views/terms_and_conditions_view.dart';
import 'package:geiger_toolbox/app/modules/tools/bindings/tools_binding.dart';
import 'package:geiger_toolbox/app/modules/tools/views/tools_view.dart';

import 'app_routes.dart';

class Pages {
  static final List<GetPage<dynamic>> pages = [
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
    GetPage(
      name: Routes.QrSCANNER_VIEW,
      page: () => QRScannerView(),
      binding: QrScannerBinding(),
    ),
    GetPage(
      name: Routes.DEVICE_VIEW,
      page: () => DeviceView(),
      binding: DeviceBinding(),
    ),
    GetPage(
      name: Routes.TERMS_AND_CONDITIONS_VIEW,
      page: () => TermsAndConditionsView(),
      binding: TermsAndConditionsBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS_VIEW,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.TOOLS_VIEW,
      page: () => ToolsView(),
      binding: ToolsBinding(),
    ),
  ];
}
