import 'package:geiger_toolbox/app/helpers/menu_item.dart';

class Routes {
  //route name
  static const HOME_PAGE = "/home-screen";
  static const COMPARE_RISK_PAGE = "/compare-risk-screen";
  static const RECOMMENDATION_PAGE = "/recommendation-screen";

  //Display page names
  static const HOME_PAGE_DISPLAY_NAME = "Home";
  static const COMPARE_RISK_DISPLAY_NAME = "Compare risk";

  static List<MenuItem> sideMenuRoutes = [
    MenuItem(name: Routes.HOME_PAGE_DISPLAY_NAME, route: Routes.HOME_PAGE),
    MenuItem(
        name: Routes.COMPARE_RISK_DISPLAY_NAME,
        route: Routes.COMPARE_RISK_PAGE),
  ];
}
