import 'dart:developer';

import 'package:geiger_api/geiger_api.dart';
import 'package:geiger_toolbox/app/services/listeners/external_plugin_event.dart';
import 'package:get/get.dart';

class GeigerApiConnector extends GetxController {
  //instance of GeigerApiConnector
  static GeigerApiConnector instance = Get.find<GeigerApiConnector>();

  //private variables
  late final GeigerApi _localMaster;
  ExternalPluginEventListener? _externalPluginEventListener;

  bool _isPluginListenerRegistered = false;

  GeigerApi get getLocalMaster {
    return _localMaster;
  }

  ExternalPluginEventListener? get getPluginListener {
    try {
      return _externalPluginEventListener;
    } catch (e) {
      log("PluginEventListener has no been initialized\n $e");
    }
  }

  /// initialize this method before the start of the app
  // LN: adding the function to handle the SCAN_COMPLETED event
  Future<void> initGeigerApi() async {
    try {
      _localMaster = (await getGeigerApi(
          "geiger_toolbox", GeigerApi.masterId, Declaration.doShareData))!;
    } catch (e) {
      log('Failed to get GeigerAPI ===> \n $e');
    }
  }

  Future<void> initRegisterExternalPluginListener(
      {required Function scanCompletedEventHandler}) async {
    //register plugin
    _isPluginListenerRegistered =
        await _registerExternalPluginListener(scanCompletedEventHandler);
  }

  Future<bool> _registerExternalPluginListener(
      Function? scanCompletedEventHandler) async {
    String id = _localMaster.id;
    if (_isPluginListenerRegistered == true) {
      log('Plugin ${_externalPluginEventListener.hashCode} has been registered and activated');
      return true;
    } else {
      if (_externalPluginEventListener == null) {
        _externalPluginEventListener = ExternalPluginEventListener(id);
        log("ExternalPluginListener ==> ${_externalPluginEventListener.hashCode}");
        // Register the function to handle the SCAN_COMPLETED event -> this function is provided from initialization of the MasterAPI (ref: main.dart)
        _externalPluginEventListener!.addMessageHandler(
            MessageType.scanCompleted, scanCompletedEventHandler!);
      }
      try {
        // List<MessageType> allEvents = MessageType.getAllValues();
        // Not sure if it is a bug of the geiger api - but we should always use [MessageType.allEvents]
        await _localMaster.registerListener(
            [MessageType.allEvents], _externalPluginEventListener!);
        log("ExternalPluginListener ==> ${_externalPluginEventListener.hashCode} has been registered and activated");
        _isPluginListenerRegistered = true;
        return true;
      } catch (e) {
        log("Failed to register listeners");
        log(e.toString());
        return false;
      }
    }
  }

  // Show some statistics of Listener
  String getListenerToString() {
    return _externalPluginEventListener.toString();
  }

}
