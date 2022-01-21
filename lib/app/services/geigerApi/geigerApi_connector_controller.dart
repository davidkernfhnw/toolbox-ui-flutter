import 'dart:developer';

import 'package:geiger_api/geiger_api.dart';
import 'package:geiger_toolbox/app/services/listeners/external_plugin_event.dart';
import 'package:get/get.dart';

class GeigerApiConnector extends GetxController {
  //instance of GeigerApiConnector
  static GeigerApiConnector instance = Get.find<GeigerApiConnector>();

  //private variables
  late final GeigerApi _localMaster;
  EventPluginEventListener? _pluginEventListener;

  bool _isPluginListenerRegistered = false;

  GeigerApi get getLocalMaster {
    return _localMaster;
  }

  EventPluginEventListener? get getPluginListener {
    try {
      return _pluginEventListener;
    } catch (e) {
      log("PluginEventListener has no been initialized\n $e");
    }
  }

  /// initialize this method before the start of the app
  // LN: adding the function to handle the SCAN_COMPLETED event
  Future<void> initGeigerApi(Function? scanCompletedEventHandler) async {
    try {
      _localMaster = (await getGeigerApi(
          "geiger_toolbox", GeigerApi.masterId, Declaration.doShareData))!;

      //register plugin
      _isPluginListenerRegistered =
          await _registerExternalPluginListener(scanCompletedEventHandler);
    } catch (e) {
      log('Failed to get GeigerAPI ===> \n $e');
    }
  }

  Future<bool> _registerExternalPluginListener(
      Function? scanCompletedEventHandler) async {
    String id = _localMaster.id;
    if (_isPluginListenerRegistered == true) {
      log('Plugin ${_pluginEventListener.hashCode} has been registered and activated');
      return true;
    } else {
      if (_pluginEventListener == null) {
        _pluginEventListener = EventPluginEventListener(id);
        log("ExternalPluginListener ==> ${_pluginEventListener.hashCode}");
        // Register the function to handle the SCAN_COMPLETED event -> this function is provided from initialization of the MasterAPI (ref: main.dart)
        _pluginEventListener!.addMessageHandler(
            MessageType.scanCompleted, scanCompletedEventHandler!);
        // An example of handling a message type (STORAGE_EVENT) with a specific handler
        _pluginEventListener!.addMessageHandler(MessageType.storageEvent,
            // Handle the Storage_event - should use the specific storage listeners
            (Message msg) {
          log('Someone ${msg.sourceId} has changed something in the Storage');
          log(msg.toString());
          Get.snackbar(
            'Storage Event',
            msg.toString(),
            duration: Duration(seconds: 10),
          );
        });
      }
      try {
        // List<MessageType> allEvents = MessageType.getAllValues();
        // Not sure if it is a bug of the geiger api - but we should always use [MessageType.allEvents]
        await _localMaster
            .registerListener([MessageType.allEvents], _pluginEventListener!);
        log("ExternalPluginListener ==> ${_pluginEventListener.hashCode} has been registered and activated");
        _isPluginListenerRegistered = true;
        return true;
      } catch (e) {
        log("Failed to register listeners");
        log(e.toString());
        return false;
      }
    }
  }

  // Dynamically define the handler for each message type
  // void _addMessageHandler(MessageType type, Function handler, String id) {
  //   if (_pluginEventListener == null) {
  //     _pluginEventListener = PluginEventListener('PluginListener-$id');
  //     log('PluginListener: ${_pluginEventListener.hashCode}');
  //   }
  //   handledEvents.add(type);
  //   _pluginEventListener!.addMessageHandler(type, handler);
  // }
  //
  // List<Message> getEvents() {
  //   return _pluginEventListener!.getEvents();
  // }

  // Show some statistics of Listener
  String getListenerToString() {
    return _pluginEventListener.toString();
  }
}
