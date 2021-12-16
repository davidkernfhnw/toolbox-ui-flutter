import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_code_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';

class QrCodePreview extends StatelessWidget {
  QrCodePreview({
    Key? key,
  }) : super(key: key);
  final QrCodeController controller = QrCodeController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 200,
      // height: 200,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 3),
      ),
      child: Obx(() {
        log(controller.data.value);
        return QrImage(
          data: controller.data.value,
          version: QrVersions.auto,
          size: 300.0,
        );
      }),
    );
  }
}
