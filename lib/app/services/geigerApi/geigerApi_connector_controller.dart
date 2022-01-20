import 'dart:developer';

import 'package:geiger_api/geiger_api.dart';
import 'package:get/get.dart';

class GeigerApiConnector extends GetxController {
  //instance of GeigerApiConnector
  static GeigerApiConnector instance = Get.find<GeigerApiConnector>();

  //private variables
  late final GeigerApi _localMaster;
  PluginEventListener? _pluginEventListener;

  List<MessageType> handledEvents = [];
  bool isListenerRegistered = false;

  GeigerApi get getLocalMaster {
    return _localMaster;
  }

  PluginEventListener? get getPluginListener {
    try {
      return _pluginEventListener;
    } catch (e) {
      log("PluginEventListener has no been initialized\n $e");
    }
  }

  /// initialize this method before the start of the app
  Future<void> initLocalMasterPlugin() async {
    //flushGeigerApiCache();
    //*****************************************master**********************
    _localMaster = (await getGeigerApi(
        "geiger_toolbox", GeigerApi.masterId, Declaration.doShareData))!;
    //clear existing state
    //await _localMaster.zapState();
    //register plugin
    isListenerRegistered = await _registerExternalPluginListener();
  }

  Future<bool> _registerExternalPluginListener() async {
    String id = _localMaster.id;
    if (isListenerRegistered == true) {
      log('Plugin ${_pluginEventListener.hashCode} has been registered and activated');
      return true;
    } else {
      if (_pluginEventListener == null) {
        _pluginEventListener = PluginEventListener(id);
        log("PluginEventListener: ${_pluginEventListener.hashCode}");
      }
      try {
        List<MessageType> allEvents = MessageType.getAllValues();
        await _localMaster.registerListener(allEvents, _pluginEventListener!);
        log("Plugin ${_pluginEventListener.hashCode} has been registered and activated");
        isListenerRegistered = true;
        return true;
      } catch (e) {
        log("Failed to register listener");
        log(e.toString());
        return false;
      }
    }
  }

  // Dynamically define the handler for each message type
  void addMessageHandler(MessageType type, Function handler, String id) {
    if (_pluginEventListener == null) {
      _pluginEventListener = PluginEventListener('PluginListener-$id');
      log('PluginListener: ${_pluginEventListener.hashCode}');
    }
    handledEvents.add(type);
    _pluginEventListener!.addMessageHandler(type, handler);
  }

  Future<MessageType?> getScanCompleteMessage() async {
    List<Message> message = await _pluginEventListener!.getEvents();

    if (message.isNotEmpty) {
      Message scanCompleted = message
          .firstWhere((element) => element.type == MessageType.scanCompleted);
      return scanCompleted.type;
    }
  }

  List<Message> getEvents() {
    return _pluginEventListener!.getEvents();
  }

  // Show some statistics of Listener
  String getListenerToString() {
    return _pluginEventListener.toString();
  }
}

class PluginEventListener implements PluginListener {
  List<Message> events = [];
  Map<MessageType, Function> messageHandler = {};
  int numberReceivedMessages = 0;
  int numberHandledMessages = 0;
  final String _id;

  PluginEventListener(this._id);

  /// Add a handler for a special message type
  /// If the message type has been handled by one handler, the old handler will be overwrided by the new one
  void addMessageHandler(MessageType type, Function handler) {
    messageHandler[type] = handler;
  }

  @override
  void pluginEvent(GeigerUrl? url, Message msg) {
    log('[Eventlistener "$_id"] received a new event ${msg.type} (source: ${msg.sourceId}, target: ${msg.targetId}');
    numberReceivedMessages++;
    events.add(msg);
    Function? handler = messageHandler[msg.type];
    if (handler != null) {
      numberHandledMessages++;
      handler(msg);
    } else {
      log('EventListener $_id does not handle message type ${msg.type}');
    }

    log('[Listener "$_id"] received a new event ${msg.type} (source: ${msg.sourceId}, target: ${msg.targetId}');
    log('Message: ${msg.toString()}');
    log('Total events: ${events.length.toString()} events');
  }

  List<Message> getEvents() {
    log("List of events=>  $events");
    return events;
  }

  @override
  String toString() {
    String ret = '';
    ret +=
        'EventListener "$_id" has received $numberReceivedMessages messages\n';
    ret += 'EventListener "$_id" has handled $numberHandledMessages messages\n';
    ret +=
        'EventListener "$_id" has dropped ${numberReceivedMessages - numberHandledMessages} messages\n';
    return ret;
  }
}
