import 'package:flutter/material.dart';
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
          _autoGenerateMenuList(),
          //_menuList(),
        ],
      ),
    );
  }
}

Widget _autoGenerateMenuList() {
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

//using this will result in controller been initialized again ex: HomeController
//
// ignore: unused_element
Widget _menuList() {
  return Column(
    children: [
      ListTile(
        title: Text(Routes.HOME_PAGE_DISPLAY_NAME),
        tileColor:
            Get.currentRoute == Routes.HOME_VIEW ? Colors.grey[300] : null,
        onTap: () {
          Get.toNamed(Routes.HOME_VIEW);
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
      ListTile(
        title: Text(Routes.DEVICE_DISPLAY_NAME),
        tileColor:
            Get.currentRoute == Routes.DEVICE_VIEW ? Colors.grey[300] : null,
        onTap: () {
          Get.toNamed(Routes.DEVICE_VIEW);
        },
      ),
      ListTile(
        title: Text(Routes.TOOLS_DISPLAY_NAME),
        tileColor:
            Get.currentRoute == Routes.TOOLS_VIEW ? Colors.grey[300] : null,
        onTap: () {
          Get.offNamed(Routes.TOOLS_VIEW);
        },
      ),
      ListTile(
        title: Text(Routes.SETTINGS_DISPLAY_NAME),
        tileColor:
            Get.currentRoute == Routes.SETTINGS_VIEW ? Colors.grey[300] : null,
        onTap: () {
          Get.offNamed(Routes.SETTINGS_VIEW);
        },
      ),
      ListTile(
        title: Text(Routes.SECURITY_DEFENDERS_DISPLAY_NAME),
        tileColor: Get.currentRoute == Routes.SECURITY_DEFENDERS_VIEW
            ? Colors.grey[300]
            : null,
        onTap: () {
          Get.offNamed(Routes.SECURITY_DEFENDERS_VIEW);
        },
      ),
    ],
  );
}

//Todo
//issues of removing screens and controllers after used from memory
// can done without iterating menu items
