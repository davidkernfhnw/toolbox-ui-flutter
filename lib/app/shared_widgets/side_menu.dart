import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/home/views/home_view.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Center(
              child: Text(
                'Geiger Toolbox',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                softWrap: true,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white30,
            ),
          ),
          autoGenerateMenuList(),
        ],
      ),
    );
  }
}

Widget autoGenerateMenuList() {
  return Column(
      children: Routes.sideMenuRoutes
          .map(
            (item) => ListTile(
              title: Text(item.name),
              tileColor:
                  Get.currentRoute == item.route ? Colors.grey[300] : null,
              onTap: () {
                //navigate and remove previous screen from the tree
                //but data will be lost
                //Get.offNamed(item.route);

                //navigate
                Get.toNamed(item.route);
              },
            ),
          )
          .toList());
}

Widget menuList() {
  return Column(
    children: [
      ListTile(
        title: Text(Routes.HOME_PAGE_DISPLAY_NAME),
        tileColor:
            Get.currentRoute == Routes.HOME_VIEW ? Colors.grey[300] : null,
        onTap: () {
          Get.off(() => HomeView());
        },
      ),
      ListTile(
        title: Text(Routes.COMPARE_RISK_DISPLAY_NAME),
        tileColor: Get.currentRoute == Routes.COMPARE_RISK_VIEW
            ? Colors.grey[300]
            : null,
        onTap: () {
          Get.offNamed(Routes.COMPARE_RISK_VIEW);
        },
      ),
      ListTile(
        title: Text(Routes.EMPLOYEE_DISPLAY_NAME),
        tileColor:
            Get.currentRoute == Routes.EMPLOYEE_VIEW ? Colors.grey[300] : null,
        onTap: () {
          Get.offNamed(Routes.EMPLOYEE_VIEW);
        },
      ),
    ],
  );
}

//Todo
//issues of removing screens and controllers after used from memory
// can done without iterating menu items
