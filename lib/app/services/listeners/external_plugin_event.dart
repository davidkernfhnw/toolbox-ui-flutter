import 'dart:developer';

import 'package:geiger_api/geiger_api.dart';

class ExternalPluginEventListener implements PluginListener {
  List<Message> events = [];
  Map<MessageType, Function> messageHandler = {};
  int numberReceivedMessages = 0;
  int numberHandledMessages = 0;
  final String _id;

  ExternalPluginEventListener(this._id);

  /// Add a handler for a special message type
  /// If the message type has been handled by one handler, the old handler will be override by the new one
  void addMessageHandler(MessageType type, Function handler) {
    messageHandler[type] = handler;
  }

  @override
  void pluginEvent(GeigerUrl? url, Message msg) {
    log('[ExternalPluginEventListener "$_id"] received a new event ${msg.type} (source: ${msg.sourceId}, target: ${msg.targetId}');
    numberReceivedMessages++;
    events.add(msg);
    Function? handler = messageHandler[msg.type];
    if (handler != null) {
      numberHandledMessages++;
      handler(msg);
    } else {
      log('ExternalPluginEventListener $_id does not handle message type ${msg.type}');
    }
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
