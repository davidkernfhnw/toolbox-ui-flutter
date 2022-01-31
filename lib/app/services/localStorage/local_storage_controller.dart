//import 'dart:developer';

import 'dart:async';
import 'dart:developer';

import 'package:geiger_api/geiger_api.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
import 'package:geiger_toolbox/app/services/listeners/storage_event.dart';
import 'package:get/get.dart' as getX;

class LocalStorageController extends getX.GetxController {
  //instance of LocalStorageController
  static LocalStorageController instance =
      getX.Get.find<LocalStorageController>();
  //get instance of GeigerApiConnector
  GeigerApiConnector _geigerApiConnector = GeigerApiConnector.instance;

  //private variables
  late StorageController _storageController;
  late GeigerApi _api;

  LocalStorageListener? _localStorageListener;

  bool _isStorageListenerRegistered = false;
  bool _isStorageListenerTriggered = false;

  StorageController get getStorageController {
    return _storageController;
  }

  LocalStorageListener get getLocalStorageListener {
    try {
      return _localStorageListener!;
    } catch (e) {
      log("LocalStorageListener has not be initialized \n$e");
      rethrow;
    }
  }

  Future<void> _initLocalStorage() async {
    try {
      _api = await _geigerApiConnector.getLocalMaster;
      _storageController = await _api.getStorage()!;
    } catch (e) {
      log("Failed to get StorageController ===> \n $e");
    }
  }

  Future<void> initRegisterStorageListener(
      {required EventType eventType,
      required Function eventHandler,
      required String path,
      String? searchKey}) async {
    // register storageListener
    _isStorageListenerRegistered = await _registerStorageListener(
        eventType, eventHandler, path, searchKey);
  }

  Future<bool> _registerStorageListener(EventType eventType,
      Function updatedEventHandler, String path, String? searchKey) async {
    if (_isStorageListenerRegistered == true) {
      log('StorageChangeListener ==> ${_localStorageListener.hashCode} has been registered and activated');
      return true;
    } else {
      if (_localStorageListener == null) {
        _localStorageListener = LocalStorageListener();
        _localStorageListener!
            .addMessageHandler(eventType, updatedEventHandler);
      }

      try {
        SearchCriteria s = SearchCriteria(searchPath: path);
        if (searchKey != null) {
          s.set(Field.key, searchKey);
        }
        await _storageController.registerChangeListener(
            _localStorageListener!, s);
        log("StorageChangeListener ==> ${_localStorageListener.hashCode} has been registered and activated");

        _isStorageListenerRegistered = true;

        try {
          Node node = await _storageController.get(path);
          //trigger evaluation
          bool e = await s.evaluate(node);
          //isTrue means ==> node fails to evaluate successfully
          if (e) {
            _isStorageListenerTriggered = false;
            log("StorageListenerTriggered ==> node FAILS to evaluate successfully");
          } else {
            _isStorageListenerTriggered = true;
            log("StorageListenerTriggered => $_isStorageListenerTriggered");
          }
          return true;
        } catch (e) {
          log("Failed to get Node from this $path \n $e");
          return false;
        }
      } catch (e) {
        log("Failed to register storageChangeListener\n $e");
        return false;
      }
    }
  }

  @override
  void onInit() async {
    await _initLocalStorage();
    super.onInit();
  }

  //close geigerApi after user
  @override
  void onClose() async {
    super.onClose();
    //await _api.close();
  }
}
