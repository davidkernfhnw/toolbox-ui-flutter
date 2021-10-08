import 'package:flutter/material.dart';
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
      body: Center(
        child: Text(
          'DeviceView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
