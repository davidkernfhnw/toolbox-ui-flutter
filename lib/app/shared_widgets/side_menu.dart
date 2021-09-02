import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SideMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
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
          ListTile(
            title: Text('Home'),
            tileColor:
                Get.currentRoute == Routes.HOME_PAGE ? Colors.grey[300] : null,
            onTap: () {
              Get.toNamed(Routes.HOME_PAGE);
            },
          ),
          ListTile(
            title: Text('Compare Risk '),
            tileColor: Get.currentRoute == Routes.COMPARE_RISK_PAGE
                ? Colors.grey[300]
                : null,
            onTap: () {
              Get.offNamed(Routes.COMPARE_RISK_PAGE);
            },
          ),
        ],
      ),
    );
  }
}
