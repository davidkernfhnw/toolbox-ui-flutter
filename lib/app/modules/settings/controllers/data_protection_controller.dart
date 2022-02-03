import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:get/get.dart';

class DataProtectionController extends GetxController {
  //instance of DataController
  static final DataProtectionController instance =
      Get.find<DataProtectionController>();

  //getting instance of localStorageController
  final LocalStorageController _localStorage = LocalStorageController.instance;

  late final StorageController _storageController;
  late final GeigerUserService _userService;
  //init storageController
  Future<void> _initStorageController() async {
    _storageController = await _localStorage.getStorageController;
  }

  var _dataAccess = false.obs;
  var _dataProcess = false.obs;

  bool get getDataAccess {
    return _dataAccess.value;
  }

  bool get getDataProcess {
    return _dataProcess.value;
  }

  Future<bool> updateDataAccess(bool value) async {
    _dataAccess.value = value;
    bool result = await _storeDataAccess(value);
    return result;
  }

  Future<bool> updateDataProcess(bool value) async {
    _dataProcess.value = value;
    bool result = await _storeDataProcess(value);
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
    super.onInit();
  }
}
