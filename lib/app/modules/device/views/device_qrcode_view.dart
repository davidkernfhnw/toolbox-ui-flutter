import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/qrcode/views/widgets/qr_code_preview.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class DeviceQrCodeView extends StatelessWidget {
  const DeviceQrCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geiger Toolbox"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QrCodePreview(),
              SizedBox(
                height: 10,
              ),
              buildPaddedText("Ask your Employee:"),
              buildPaddedText("1. To Open the GEIGER Toolbox on their device."),
              buildPaddedText(
                  '2. To select the tab “Employees” & press the button “QR Code”.'),
              buildPaddedText(
                  "3. Point your Phone to their screen to scan the code."),
            ],
          ),
        ),
      ),
    );
  }
}
