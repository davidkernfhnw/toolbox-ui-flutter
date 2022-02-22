import 'dart:async';
import 'dart:developer';

import 'package:geiger_localstorage/geiger_localstorage.dart';

class Event {
  final EventType _event;
  final Node? _old;
  final Node? _new;

  Event(this._event, this._old, this._new);

  EventType get type => _event;

  Node? get oldNode => _old;

  Node? get newNode => _new;

  @override
  String toString() {
    return '${type.toString()} ${oldNode.toString()}=>${newNode.toString()}';
  }
}

class LocalStorageListener implements StorageListener {
  List<Event> events = <Event>[];
  Map<EventType, Function> messageHandler = {};
  int numberReceivedEvents = 0;
  int numberHandledEvents = 0;

  /// Add a handler for a special message type
  /// If the storage Event type has been handled by one handler, the old handler will be override by the new one
  void addMessageHandler(EventType type, Function handler) {
    messageHandler[type] = handler;
  }

  @override
  Future<void> gotStorageChange(
      EventType event, Node? oldNode, Node? newNode) async {
    Event e = Event(event, oldNode, newNode);
    log('localStorageEventListener received a NEW EVENT ==> ${e._event}\n OLD NODE ==> ${e.oldNode} \n NEW NODE ==> ${e.newNode}');
    numberReceivedEvents++;
    events.add(e);
    Function? handler = messageHandler[e.type];
    if (handler != null) {
      numberHandledEvents++;
      handler(e);
    } else {
      log("localStorageEventListener does not handle message type ${e.type}");
    }
  }

  List<Event> getEvents() {
    log("List of events=>  $events");
    return events;
  }

  @override
  String toString() {
    String ret = '';
    ret +=
        'localStorageEventListener has received $numberReceivedEvents events\n';
    ret +=
        'localStorageEventListener has handled $numberHandledEvents events\n';
    ret +=
        'localStorageEventListener has dropped ${numberReceivedEvents - numberHandledEvents} messages\n';
    return ret;
  }
}
