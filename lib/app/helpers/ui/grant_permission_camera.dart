import 'package:geiger_toolbox/app/helpers/ui/grant_permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class GrantPermissionCamera extends GrantPermissionHelper {
  GrantPermissionCamera() : super(Permission.camera);
}
