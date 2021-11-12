import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/widgets/tab_bar_builder.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:geiger_toolbox/app/modules/settings/views/widgets/data_protection.dart';
import 'package:geiger_toolbox/app/modules/settings/views/widgets/profile_view.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);
  final SettingsController _controller = SettingsController.to;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        endDrawerEnableOpenDragGesture: false,
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
          physics: NeverScrollableScrollPhysics(),
          children: [
            ProfileView(controller: _controller),
            DataProtection(),
            Container(
              child: Text("3"),
            ),
          ],
        ),
      ),
    );
  }
}
