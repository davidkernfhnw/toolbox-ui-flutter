import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/widgets/tab_bar_builder.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/data_controller.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/data_protection_controller.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:geiger_toolbox/app/modules/settings/views/widgets/data_protection_view.dart';
import 'package:geiger_toolbox/app/modules/settings/views/widgets/data_view.dart';
import 'package:geiger_toolbox/app/modules/settings/views/widgets/profile_view.dart';
import 'package:geiger_toolbox/app/shared_widgets/showCircularProgress.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);
  final SettingsController _settingsController = SettingsController.instance;
  final DataController _dataController = DataController.instance;
  final DataProtectionController _dataProtectionController =
      DataProtectionController.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        endDrawerEnableOpenDragGesture: false,
        drawer: SideMenu(),
        appBar: AppBar(
          title: Text('title'.tr),
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
              text: "Data",
            ),
          ]),
        ),
        body: Obx(() {
          return _settingsController.isLoading.value == true
              ? Center(
                  child: ShowCircularProgress(
                    visible: _settingsController.isLoading.value,
                  ),
                )
              : TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ProfileView(controller: _settingsController),
                    DataProtectionView(controller: _dataProtectionController),
                    DataView(controller: _dataController),
                  ],
                );
        }),
      ),
    );
  }
}
