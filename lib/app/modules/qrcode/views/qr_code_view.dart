import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeView extends StatelessWidget {
  const QrCodeView({Key? key}) : super(key: key);

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
              Container(
                // width: 200,
                // height: 200,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 3)),
                child: QrImage(
                  data: "1234567890",
                  version: QrVersions.auto,
                  size: 300.0,
                ),
              ),
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
