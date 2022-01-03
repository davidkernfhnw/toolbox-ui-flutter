import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_scanner_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerPreview extends StatelessWidget {
  const QrScannerPreview({Key? key, required this.controller})
      : super(key: key);
  final QrScannerController controller;
  @override
  Widget build(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: controller.qrKey,
      onQRViewCreated: controller.onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 2,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }
}
