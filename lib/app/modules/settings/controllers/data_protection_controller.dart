import 'dart:developer';

import 'package:geiger_api/geiger_api.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_user_service.dart';
import 'package:get/get.dart';

import '../../../model/user.dart';
import '../../../services/cloudReplication/cloud_replication_controller.dart';

class DataProtectionController extends GetxController {
  //instance of DataController
  static final DataProtectionController instance =
      Get.find<DataProtectionController>();

  //getting instance of localStorageController
  final LocalStorageController _localStorage = LocalStorageController.instance;

  final CloudReplicationController _cloudReplicationInstance =
      CloudReplicationController.instance;
  final GeigerApiConnector _geigerApiConnectorInstance =
      GeigerApiConnector.instance;
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

  Rx<int> doNoShareValue = 0.obs;
  Rx<int> replicateValue = 1.obs;

  Rx<int> isRadioSelected = 0.obs;

  RxList<MenuItem> externalPluginMenuList = <MenuItem>[].obs;

  String? currentLanguage;

  bool get getDataAccess {
    return _dataAccess.value;
  }

  void set setDataAccess(bool value) {
    _dataAccess.value = value;
  }

  bool get getReplicationConsent {
    if (isRadioSelected.value == 1) {
      return true;
    } else {
      return false;
    }
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
  Future<bool> initReplication() async {
    log("replication called");

    //initialReplication
    bool result = await _cloudReplicationInstance.initialReplication();

    return result;
  }

  // ignore: unused_element
  Future<bool?> _checkForReplication() async {
    bool check = await _cloudReplicationInstance.checkReplication();
    if (check) {
      bool success = await initReplication();
      return success;
    } else {
      replicationError.value = "Replication has been done";
      return null;
    }
  }

  Future<void> _getReplicateConsent() async {
    int? rep = await _userService.getReplicateConsent;
    int? noData = await _userService.getDoNotShareConsent;
    if (rep != null && noData != null) {
      if (rep == isRadioSelected.value) {
        isRadioSelected.value = 1;
      } else {
        isRadioSelected.value = 0;
      }
    }
  }

  Future<void> updateDoNotShare(int newValue) async {
    await _userService.updateDoNotShareConsent(doNotShareData: newValue);
  }

  Future<void> updateReplicateConsent(int newValue) async {
    await _userService.updateReplicateConsent(replicateData: newValue);
  }

  //send request to chat box to send menuItems
  void getExternalPluginMenuItems(bool menuPressed) async {
    if (menuPressed) {
      //call to set current language from the local storage
      _getCurrentLanguage();
      externalPluginMenuList.value =
          await _geigerApiConnectorInstance.getMenuItems();
      log("MenuItems ==> ${externalPluginMenuList}");
    }
  }

  void _getCurrentLanguage() async {
    User? user = await _userService.getUserInfo;
    if (user != null) {
      currentLanguage = user.language;
    }
  }

  @override
  void onInit() async {
    await _initStorageController();
    await _getUserConsent();

    _getReplicateConsent();
    // log("DUMP ON data protection ${await _storageController.dump(":Global:cert")}");
    super.onInit();
  }
}
