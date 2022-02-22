import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  SideMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Center(
            child: Text(
              "geiger-toolbox".tr,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
              softWrap: true,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white30,
          ),
        ),
        menuItems()

        //_menuList(),
      ],
    ));
  }
}

Widget menuItems() {
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
