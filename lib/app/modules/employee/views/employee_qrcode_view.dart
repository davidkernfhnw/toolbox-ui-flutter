import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/qrcode/views/widgets/qr_code_preview.dart';

class EmployeeQrCodeView extends StatelessWidget {
  const EmployeeQrCodeView({Key? key}) : super(key: key);

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
              Text(
                "By letting your supervisor adding you to their toolbox no "
                "data will be shared automatically.",
                softWrap: true,
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 5,
              ),
              Text("You will need to actively share your Risk Score.",
                  softWrap: true, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
