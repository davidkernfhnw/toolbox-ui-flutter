import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/recommendation/views/widgets/tab_bar_builder.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/data_protection_controller.dart';
import 'package:geiger_toolbox/app/modules/settings/views/widgets/data_protection_view.dart';
import 'package:geiger_toolbox/app/modules/settings/views/widgets/data_view.dart';
import 'package:geiger_toolbox/app/modules/settings/views/widgets/profile_view.dart';
import 'package:geiger_toolbox/app/shared_widgets/showCircularProgress.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);
  final DataProtectionController _dataProtectionController =
      DataProtectionController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DefaultTabController(
        initialIndex: _dataProtectionController.getDataAccess ? 0 : 1,
        length: 3,
        child: Scaffold(
          endDrawerEnableOpenDragGesture: false,
          drawerEnableOpenDragGesture: false,
          drawer: SideMenu(),
          appBar: AppBar(
            //hide menuIcon if data access is not enabled
            automaticallyImplyLeading: _dataProtectionController.getDataAccess,
            title: Text('title-settings'.tr),
            centerTitle: true,
            bottom: buildTabBar(tabs: [
              Tab(
                icon: Icon(
                  Icons.person_pin_outlined,
                ),
                text: "profile".tr,
              ),
              Tab(
                icon: Icon(
                  Icons.storage_outlined,
                ),
                text: "data-protection".tr,
              ),
              Tab(
                icon: Icon(
                  Icons.storage_outlined,
                ),
                text: "data".tr,
              ),
            ]),
          ),
          body: Obx(() {
            return _dataProtectionController.isLoading.value == true
                ? Center(
                    child: ShowCircularProgress(
                      visible: _dataProtectionController.isLoading.value,
                    ),
                  )
                : TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ProfileView(),
                      DataProtectionView(),
                      DataView(),
                    ],
                  );
          }),
        ),
      );
    });
  }
}
