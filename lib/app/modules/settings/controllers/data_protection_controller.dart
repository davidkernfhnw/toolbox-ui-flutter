import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/modules/home/controllers/home_controller.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:get/get.dart';

class DataProtectionController extends GetxController {
  //instance of DataController
  static final DataProtectionController instance =
      Get.find<DataProtectionController>();

  //getting instance of localStorageController
  final LocalStorageController _localStorage = LocalStorageController.instance;
  final HomeController _homeControllerInstance = HomeController.instance;

  late final StorageController _storageController;
  late final GeigerUserService _userService;
  //init storageController
  Future<void> _initStorageController() async {
    _storageController = await _localStorage.getStorageController;
  }

  var _dataAccess = false.obs;
  var _dataProcess = false.obs;
  var isLoading = false.obs;

  bool get getDataAccess {
    return _dataAccess.value;
  }

  bool get getDataProcess {
    return _dataProcess.value;
  }

  Future<bool> updateDataAccess(bool value) async {
    isLoading.value = false;
    _dataAccess.value = value;
    bool result = await _storeDataAccess(value);
    if (value) {
      _homeControllerInstance.dataAccess.value = true;
    } else {
      _homeControllerInstance.dataAccess.value = false;
    }
    log("DataAccess status ${_homeControllerInstance.dataAccess.value}");
    bool? check = await _userService.checkUserConsent();
    if (check!) {
      _homeControllerInstance.checkConsent();
    }
    isLoading.value = false;
    return result;
  }

  Future<bool> updateDataProcess(bool value) async {
    isLoading.value = true;
    _dataProcess.value = value;
    bool result = await _storeDataProcess(value);
    if (value) {
      _homeControllerInstance.dataProcess.value = true;
    } else {
      _homeControllerInstance.dataProcess.value = false;
    }

    log("dataProcess status ${_homeControllerInstance.dataProcess.value}");
    bool? check = await _userService.checkUserConsent();
    if (check!) {
      _homeControllerInstance.checkConsent();
    }
    isLoading.value = false;
    return result;
  }

  Future<void> _getUserConsent() async {
    bool? process = await _userService.getUserConsentDataProcess;
    bool? access = await _userService.getUserConsentDataAccess;
    if (process != null && access != null) {
      _dataProcess.value = process;
      _dataAccess.value = access;
    }
  }

  Future<bool> _storeDataAccess(bool value) async {
    bool success =
        await _userService.updateUserConsentDataAccess(dataAccess: value);
    return success;
  }

  Future<bool> _storeDataProcess(bool value) async {
    bool success =
        await _userService.updateUserConsentDataProcess(dataProcess: value);
    return success;
  }

  @override
  void onInit() async {
    await _initStorageController();
    _userService = GeigerUserService(_storageController);
    await _getUserConsent();
    log("DUMP ON SETTING ${await _storageController.dump(":Global:cert")}");
    super.onInit();
  }
}
