import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Geiger Toolbox'),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
          ListTile(
            title: Text('Home'),
            tileColor:
                Get.currentRoute == '/scanRiskScreen' ? Colors.grey[300] : null,
            onTap: () {
              Get.toNamed('/scanRiskScreen');
            },
          ),
          ListTile(
            title: Text('Compare Risk '),
            tileColor: Get.currentRoute == '/compareRiskScreen'
                ? Colors.grey[300]
                : null,
            onTap: () {
              Get.offNamed('/compareRiskScreen');
            },
          ),
        ],
      ),
    );
  }
}
