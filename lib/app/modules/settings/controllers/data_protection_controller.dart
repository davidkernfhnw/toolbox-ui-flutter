import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:get/get.dart';

import '../../../services/cloudReplication/cloud_replication_controller.dart';

class DataProtectionController extends GetxController {
  //instance of DataController
  static final DataProtectionController instance =
      Get.find<DataProtectionController>();

  //getting instance of localStorageController
  final LocalStorageController _localStorage = LocalStorageController.instance;

  final CloudReplicationController _cloudReplicationInstance =
      CloudReplicationController.instance;

  late final StorageController _storageController;
  late final GeigerUserService _userService;
  //init storageController
  Future<void> _initStorageController() async {
    _storageController = await _localStorage.getStorageController;
    _userService = GeigerUserService(_storageController);
  }

  var _dataAccess = false.obs;
  var isLoading = false.obs;
  var isLoadingServices = false.obs;
  var message = "".obs;
  var replicationError = "".obs;

  Rx<int> isRadioSelected = 0.obs;

  bool get getDataAccess {
    return _dataAccess.value;
  }

  void set setDataAccess(bool value) {
    _dataAccess.value = value;
  }

  Future<bool> updateDataAccess(bool value) async {
    isLoading.value = true;
    bool result = await _storeDataAccess(value);
    if (value) {
      _dataAccess.value = value;
    } else {
      _dataAccess.value = false;
    }
    log("DataAccess status ${_dataAccess.value}");
    isLoading.value = false;
    return result;
  }

  Future<void> _getUserConsent() async {
    bool? access = await _userService.getUserConsentDataAccess;
    if (access != null) {
      _dataAccess.value = access;
    }
  }

  Future<bool> _storeDataAccess(bool value) async {
    bool success =
        await _userService.updateUserConsentDataAccess(dataAccess: value);
    return success;
  }

  // ignore: unused_element
  Future<bool> _initReplication() async {
    isLoading.value = true;
    log("replication called");
    message.value = "Update....";

    //initialReplication
    bool result = await _cloudReplicationInstance.initialReplication();

    message.value = "Replicating user dara...";

    //log("isLoading is : $isLoadingServices");
    message.value = "Almost done!";
    isLoading.value = false;
    return result;
  }

  Future<bool?> checkForReplication() async {
    bool check = await _cloudReplicationInstance.checkReplication();
    if (check) {
      bool success = await _initReplication();
      return success;
    } else {
      replicationError.value = "Replication has been done";
      return null;
    }
  }

  @override
  void onInit() async {
    await _initStorageController();
    await _getUserConsent();
    // log("DUMP ON data protection ${await _storageController.dump(":Global:cert")}");
    super.onInit();
  }
}
