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
  List<MessageType> _handledEvents = [];
  GeigerApi get getLocalMaster {
    return _localMaster;
  }

  /// initialize this method before the start of the app
  Future<void> initGeigerApi() async {
    try {
      //Todo ==> Declaration should be changed,
      //Todo ==> get correct initialization of geigerApi from Martin
      _localMaster = (await getGeigerApi(
          "", GeigerApi.masterId, Declaration.doShareData))!;
    } catch (e) {
      log('Failed to get GeigerAPI ===> \n $e');
    }
  }

  // Register the External Plugin listener to listen all messages (events)
  Future<bool> _registerListener() async {
    String id = _localMaster.id;
    if (_isPluginListenerRegistered == true) {
      log('Plugin ${_externalPluginEventListener.hashCode} has been registered already!');
      return true;
    } else {
      if (_externalPluginEventListener == null) {
        _externalPluginEventListener = ExternalPluginEventListener(id);
        log('External Plugin ${_externalPluginEventListener.hashCode}');
      }
      try {
        // await pluginApi!
        //     .registerListener(handledEvents, pluginListener!); // This should be correct one
        await _localMaster.registerListener(
            [MessageType.allEvents], _externalPluginEventListener!);
        await _localMaster.registerListener(
            [MessageType.registerPlugin], _externalPluginEventListener!);
        log('External Plugin ${_externalPluginEventListener!.hashCode} has been registered and activated');
        _isPluginListenerRegistered = true;
        return true;
      } catch (e) {
        log('Failed to register listener');
        log(e.toString());
        return false;
      }
    }
  }

  // Dynamically define the handler for each message type
  void addMessageHandler(MessageType type, Function handler) {
    log("addMessageHandler called");
    String id = _localMaster.id;
    if (_externalPluginEventListener == null) {
      _externalPluginEventListener = ExternalPluginEventListener(id);
      log('External PluginListener: ${_externalPluginEventListener.hashCode}');
    }
    _handledEvents.add(type);
    _externalPluginEventListener!.addMessageHandler(type, handler);
  }

// Send a simple message which contain only the message type to specific external plugin
  Future<bool> sendAMessageType(
      MessageType messageType, String pluginId) async {
    try {
      log('Trying to send a message type $messageType');
      final GeigerUrl testUrl = GeigerUrl.fromSpec('geiger://${pluginId}/test');
      final Message request = Message(
        GeigerApi.masterId,
        pluginId,
        messageType,
        testUrl,
      );
      await _localMaster.sendMessage(request);
      log('A message type $messageType has been sent successfully');
      return true;
    } catch (e) {
      log('Failed to send a message type $messageType');
      log(e.toString());
      return false;
    }
  }

  // Get the list of received messages
  List<Message> getAllMessages() {
    return _externalPluginEventListener!.getEvents();
  }

  Future menuPressed(GeigerUrl url) async {
    _localMaster.menuPressed(url);
  }

  Future<List<MenuItem>> getMenuItems() async {
    log("MenuItems called");
    List<MenuItem> menuList = [];

    try {
      menuList = _localMaster.getMenuList();
    } catch (e) {
      log(e.toString());
    }

    return menuList;
  }

  // Show some statistics of Listener
  String getListenerToString() {
    return _externalPluginEventListener.toString();
  }

  //register plugin Listener when geigerAPi is already initialized
  @override
  void onReady() async {
    await _registerListener();
    super.onReady();
  }
}
