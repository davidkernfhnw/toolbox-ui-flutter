import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SideMenuBar extends StatelessWidget {
  const SideMenuBar({Key? key}) : super(key: key);
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
          Column(
            children: Routes.sideMenuRoutes
                .map(
                  (item) => ListTile(
                    title: Text(item.name),
                    tileColor: Get.currentRoute == item.route
                        ? Colors.grey[300]
                        : null,
                    onTap: () {
                      //navigate and remove previous screen from the tree
                      Get.offNamed(item.route);
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
