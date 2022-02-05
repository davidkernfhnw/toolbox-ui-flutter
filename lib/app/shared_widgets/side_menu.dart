import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  final HomeController controller = HomeController.instance;

  SideMenu({Key? key}) : super(key: key);
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
