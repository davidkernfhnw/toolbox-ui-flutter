import 'package:flutter/material.dart';
import 'package:geiger_toolbox/routes/routes.dart';
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
                Get.currentRoute == Routes.SCAN_RISK ? Colors.grey[300] : null,
            onTap: () {
              Get.toNamed(Routes.SCAN_RISK);
            },
          ),
          ListTile(
            title: Text('Compare Risk '),
            tileColor: Get.currentRoute == Routes.COMPARE_RISK
                ? Colors.grey[300]
                : null,
            onTap: () {
              Get.offNamed(Routes.COMPARE_RISK);
            },
          ),
        ],
      ),
    );
  }
}
