import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tools_controller.dart';

class ToolsView extends GetView<ToolsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToolsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ToolsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
