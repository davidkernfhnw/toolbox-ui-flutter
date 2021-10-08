import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/device/views/device_qrcode_view.dart';
import 'package:geiger_toolbox/app/modules/device/views/widgets/device_card.dart';

import 'package:geiger_toolbox/app/shared_widgets/EmployeeCard.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';

import 'package:get/get.dart';

import '../controllers/device_controller.dart';

class DeviceView extends GetView<DeviceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DeviceView'),
      ),
      drawer: SideMenuBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          DeviceCard(
            onPress: () {
              Get.to(() => DeviceQrCodeView());
            },
          ),
          EmployeeCard(
              title: "Other Devices",
              msgBody:
                  "Pair devices that have the toolbox installed and monitor their risks",
              btnIcon: Icon(Icons.camera_alt),
              btnText: "Add a Device")
        ]),
      ),
    );
  }
}
