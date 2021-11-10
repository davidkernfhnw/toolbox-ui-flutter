import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/widgets/tab_bar_builder.dart';
import 'package:geiger_toolbox/app/modules/settings/views/widgets/profile_view.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(
          title: Text("Settings"),
          centerTitle: true,
          bottom: buildTabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.person_pin_outlined,
              ),
              text: "Profile",
            ),
            Tab(
              icon: Icon(
                Icons.storage_outlined,
              ),
              text: "Data Protection",
            ),
            Tab(
              icon: Icon(
                Icons.storage_outlined,
              ),
              text: "Edit Data",
            ),
          ]),
        ),
        body: TabBarView(
          children: [
           ProfileView(),
            Container(
              child: Text("2"),
            ),
            Container(
              child: Text("3"),
            ),
          ],
        ),
      ),
    );
  }
}
