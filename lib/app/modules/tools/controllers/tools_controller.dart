import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/model/tool.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_data_service.dart';
import 'package:get/get.dart';

class ToolsController extends GetxController {
  static ToolsController instance = Get.find<ToolsController>();
  final LocalStorageController _storageControllerInstance =
      LocalStorageController.instance;

  //**** late variables ******
  late final StorageController _storageController;
  late final GeigerDataService _geigerDataService;

  RxList<Tool> tools = <Tool>[].obs;
  var installed = false.obs;

  Future<void> ini() async {
    _storageController = await _storageControllerInstance.getStorageController;
    _geigerDataService = GeigerDataService(_storageController);
  }

  void _externalTools() async {
    tools.value = await _geigerDataService.showExternalTools();
    log("Tools ==> ${tools}");
  }

  @override
  void onInit() async {
    await ini();
    _externalTools();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
