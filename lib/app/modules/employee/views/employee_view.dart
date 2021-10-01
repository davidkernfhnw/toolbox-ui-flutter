import 'package:flutter/material.dart';
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
      body: Center(
        child: Text(
          'EmployeeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
