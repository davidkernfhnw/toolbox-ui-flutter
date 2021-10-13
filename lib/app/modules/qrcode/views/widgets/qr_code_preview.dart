import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePreview extends StatelessWidget {
  const QrCodePreview({
    Key? key,
  }) : super(key: key);

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
      child: QrImage(
        data: "1234567890",
        version: QrVersions.auto,
        size: 300.0,
      ),
    );
  }
}
