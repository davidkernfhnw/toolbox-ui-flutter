import 'dart:io';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/user.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DataController extends GetxController {
  //instance of DataController
  static final DataController instance = Get.find<DataController>();
  //getting instance of localStorageController
  final LocalStorageController _localStorage = LocalStorageController.instance;

  late final StorageController _storageController;
  //userService
  late final GeigerUserService _userService;

  Future<String> showRawData() async {
    User? userInfo = await _userService.getUserInfo;
    if (userInfo != null) {
      String userPath = ":Users:${userInfo.userId}";
      String devicePath = ":Devices:${userInfo.deviceOwner!.deviceId}";
      String u = await _storageController.dump(userPath);
      String d = await _storageController.dump(devicePath);

      return u + d;
    } else {
      return "NO Data Available";
    }
  }

  //not tested
  void makeJsonFile() async {
    String value = await showRawData();
    final Directory directory = await getApplicationDocumentsDirectory();
    String path =
        directory.path + Platform.pathSeparator + "geiger_Toolbox_data.json";
    final File file = File(path);

    File update = await file.writeAsString(value);

    await Share.shareFiles([path], text: "geiger_Toolbox_data");
    await update.delete();
  }

  //init storageController
  Future<void> _initStorageController() async {
    _storageController = await _localStorage.getStorageController;
    _userService = GeigerUserService(_storageController);
  }

  @override
  void onInit() async {
    await _initStorageController();
    super.onInit();
  }
}
