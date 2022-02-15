import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/device/controllers/device_controller.dart';
import 'package:geiger_toolbox/app/modules/device/views/widgets/device_card.dart';
import 'package:geiger_toolbox/app/modules/device/views/widgets/device_owner_card.dart';
import 'package:geiger_toolbox/app/modules/device/views/widgets/device_qrcode_view.dart';
import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_scanner_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/shared_widgets/EmployeeCard.dart';
import 'package:geiger_toolbox/app/shared_widgets/empty_space_card.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:geiger_toolbox/app/util/style.dart';
import 'package:get/get.dart';

import '../../settings/controllers/data_protection_controller.dart';

class DeviceView extends StatelessWidget {
  DeviceView({Key? key}) : super(key: key);
  //instance of QrScannerController
  final QrScannerController _qrController = QrScannerController();
  final DeviceController _deviceController = DeviceController.instance;
  final DataProtectionController _dataProtectionController =
      DataProtectionController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DeviceView'),
      ),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DeviceOwnerCard(
                  onPress: _dataProtectionController.getDataAccess
                      ? () {
                          Get.to(() => DeviceQrCodeView());
                        }
                      : null),
              Text(_deviceController.devices.toString()),
              QrScannerCard(
                  title: "Other Devices",
                  msgBody:
                      "Pair devices that have the toolbox installed and monitor their risks",
                  btnIcon: Icon(Icons.camera_alt),
                  btnText: "Add a Device",
                  onScan: !Platform.isWindows ||
                          !Platform.isMacOS ||
                          !Platform.isLinux
                      ? _dataProtectionController.getDataAccess
                          ? () {
                              _qrController.requestCameraPermission(
                                  Routes.QrSCANNER_VIEW,
                                  arguments: "Pair a new device");
                            }
                          : null
                      : () {
                          Get.defaultDialog(
                            middleText:
                                "Sorry functionality not yet available for Desktop",
                            cancel: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("Ok")),
                          );
                        }),
              SizedBox(
                height: 5,
              ),
              boldText("Other Paired Devices"),
              EmptySpaceCard(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: ListTile.divideTiles(
                        //          <-- ListTile.divideTiles
                        context: context,
                        tiles: [
                          DeviceCard(
                            device: Icon(Icons.phone_android),
                          ),
                          DeviceCard(
                            device: Icon(Icons.desktop_windows),
                          ),
                        ]).toList(),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
