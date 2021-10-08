import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_scanner_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get/get.dart';

class QRScannerView extends StatefulWidget {
  const QRScannerView({Key? key}) : super(key: key);

  @override
  _QRScannerViewState createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  //get instance QrViewController
  QrScannerController qrScannerViewController = QrScannerController.to;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrScannerViewController.qrViewController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrScannerViewController.qrViewController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geiger Toolbox"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: GetBuilder<QrScannerController>(
                init: QrScannerController(),
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: buildQrView(_),
                  );
                }),
          ),
          GetBuilder<QrScannerController>(
              init: QrScannerController(),
              builder: (_) {
                return Expanded(
                  flex: 2,
                  child: (_.result != null)
                      ? Text(
                          "Barcode Type: ${describeEnum(_.result!.format)}   Data: ${_.result!.code}")
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              buildPaddedText("Ask your Employee:"),
                              buildPaddedText(
                                  "1. To Open the GEIGER Toolbox on their device."),
                              buildPaddedText(
                                  '2. To select the tab “Employees” & press the button “QR Code”.'),
                              buildPaddedText(
                                  "3. Point your Phone to their screen to scan the code.")
                            ],
                          ),
                        ),
                );
              })
        ],
      ),
    );
  }

  Padding buildPaddedText(String text) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        width: 500,
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  QRView buildQrView(QrScannerController _) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: _.qrKey,
      onQRViewCreated: _.onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 2,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }
}
