import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/qrcode/controllers/qr_scanner_controller.dart';
import 'package:geiger_toolbox/app/modules/qrcode/views/widgets/qr_scanner_preview.dart';
import 'package:geiger_toolbox/app/shared_widgets/showCircularProgress.dart';
import 'package:geiger_toolbox/app/util/style.dart';
import 'package:get/get.dart';

class QRScannerView extends StatefulWidget {
  const QRScannerView({Key? key}) : super(key: key);

  @override
  _QRScannerViewState createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  //get instance QrViewController
  QrScannerController qrScannerViewController = QrScannerController.instance;

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
        title: Text(qrScannerViewController.viewTitle.value),
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
                    child: Obx(() {
                      return Stack(children: [
                        _.isScanning.value == true
                            ? Center(
                                child: ShowCircularProgress(
                                  visible: true,
                                ),
                              )
                            : QrScannerPreview(controller: _),
                      ]);
                    }),
                  );
                }),
          ),
          GetBuilder<QrScannerController>(
              init: QrScannerController(),
              builder: (_) {
                return Expanded(
                    flex: 2,
                    child: _.viewTitle == "Add an employee"
                        ? SingleChildScrollView(
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
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                buildPaddedText(
                                    "1. Open the GEIGER Toolbox on your other  device."),
                                buildPaddedText('2. Select the Tab “Devices”.'),
                                buildPaddedText(
                                    "3. Select “QR Code” and scan it with this camera.")
                              ],
                            ),
                          ));
              })
        ],
      ),
    );
  }
}
