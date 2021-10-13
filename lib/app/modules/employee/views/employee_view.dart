import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/employee/controllers/employee_controller.dart';
import 'package:geiger_toolbox/app/modules/employee/views/employee_qrcode_view.dart';
import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_scanner_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/shared_widgets/EmployeeCard.dart';

import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:get/get.dart';

class EmployeeView extends StatelessWidget {
  EmployeeView({Key? key}) : super(key: key);

  //instance of EmployeeController
  final EmployeeController controller = EmployeeController.to;
  //instance of QrScannerController
  final QrScannerController qrController = QrScannerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee'),
      ),
      drawer: SideMenuBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            EmployeeCard(
              title: "Your Supervisor",
              msgBody: "Connect a responsible person who has the overview"
                  " of the employee scores",
              btnIcon: Icon(Icons.qr_code_scanner),
              btnText: "QR Code",
              onScan: () => Get.to(() => EmployeeQrCodeView()),
            ),
            EmployeeCard(
                title: "Your Employee",
                msgBody: "Connect your toolbox with your employees "
                    "to be able to follow their achievements",
                btnIcon: Icon(Icons.camera_alt),
                btnText: "Add an Employee",
                onScan: () async {
                  await qrController.requestCameraPermission(
                      Routes.QrSCANNER_VIEW,
                      arguments: "Add an employee");

                  //controller.requestCameraPermission();
                })
          ],
        ),
      ),
    );
  }
}
