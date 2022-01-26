import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

/// handles .isLimited for iOS 14+ where we can restrict access.
abstract class GrantPermissionHelper {
  final Permission permission;
  GrantPermissionHelper(this.permission);

  Future<void> request(
      {required final void Function() onPermanentlyDenied,
      required final void Function() onGranted}) async {
    PermissionStatus status = await permission.request();
    log("GrantPermissionHelp status: $status");

    if (status.isPermanentlyDenied) {
      log("GrantPermissionHelper: DeniedPermanently");
      onPermanentlyDenied.call();
      return;
    }
    if (!status.isLimited && !status.isGranted) {
      final PermissionStatus result = await permission.request();
      if (!result.isGranted) {
        return;
      }
    }
    onGranted.call();
  }
}
