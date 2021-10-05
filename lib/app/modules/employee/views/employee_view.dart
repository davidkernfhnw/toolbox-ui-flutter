import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/employee/views/widgets/EmployeeCard.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';

class EmployeeView extends StatelessWidget {
  const EmployeeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EmployeeView'),
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
              onScan: null,
            ),
            EmployeeCard(
              title: "Your Employee",
              msgBody: "Connect your toolbox with your employees "
                  "to be able to follow their achievements",
              btnIcon: Icon(Icons.camera_alt),
              btnText: "Add an Employee",
              onScan: null,
            )
          ],
        ),
      ),
    );
  }
}
