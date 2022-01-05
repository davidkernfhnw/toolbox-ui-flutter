import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/employee/controllers/employee_controller.dart';
import 'package:geiger_toolbox/app/modules/employee/views/widgets/employee_qrcode_view.dart';
import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_scanner_controller.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/shared_widgets/EmployeeCard.dart';
import 'package:geiger_toolbox/app/shared_widgets/empty_space_card.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';
import 'package:geiger_toolbox/app/util/style.dart';
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
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QrScannerCard(
              title: "Your Supervisor",
              msgBody: "Connect a responsible person who has the overview"
                  " of the employee scores",
              btnIcon: Icon(Icons.qr_code_scanner),
              btnText: "QR Code",
              onScan: () => Get.to(() => EmployeeQrCodeView()),
            ),
            QrScannerCard(
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
                }),
            SizedBox(
              height: 5,
            ),
            boldText("Your Employees"),
            EmptySpaceCard(
              //Todo: Make your data as a list Object and return a EmployeeCard
              child: ListView(
                children: ListTile.divideTiles(
                    //          <-- ListTile.divideTiles
                    context: context,
                    tiles: [
                      EmployeeCard(),
                      EmployeeCard(),
                      EmployeeCard(),
                      EmployeeCard(),
                    ]).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText("Samsung Galaxy s8"),
                  greyText("Score shared on: 17.03.21")
                ],
              ),
              Column(
                children: [
                  Text(
                    "34",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  greyText("Low"),
                ],
              ),
              IconButton(
                onPressed: null,
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
