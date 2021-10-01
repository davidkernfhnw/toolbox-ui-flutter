import 'package:geiger_toolbox/app/helpers/menu_item.dart';

class Routes {
  //route name
  static const HOME_VIEW = "/home-view";
  static const COMPARE_RISK_VIEW = "/compare-risk-view";
  static const RECOMMENDATION_VIEW = "/recommendation-view";
  static const EMPLOYEE_VIEW = "/employee-view";

  //Display page names
  static const HOME_PAGE_DISPLAY_NAME = "Home";
  static const COMPARE_RISK_DISPLAY_NAME = "Compare risk";
  static const EMPLOYEE_DISPLAY_NAME = "Employee";

  static List<MenuItem> sideMenuRoutes = [
    MenuItem(name: Routes.HOME_PAGE_DISPLAY_NAME, route: Routes.HOME_VIEW),
    MenuItem(
        name: Routes.COMPARE_RISK_DISPLAY_NAME,
        route: Routes.COMPARE_RISK_VIEW),
    MenuItem(name: Routes.EMPLOYEE_DISPLAY_NAME, route: Routes.EMPLOYEE_VIEW)
  ];
}
