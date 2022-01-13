//import 'dart:developer';

import 'dart:async';
import 'dart:developer';

import 'package:geiger_api/geiger_api.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/services/geigerApi/geigerApi_connector_controller.dart';
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

  StorageController get getStorageController {
    return _storageController;
  }

  Future<void> _initLocalStorage() async {
    try {
      _api = await _geigerApiConnector.getLocalMaster;
      _storageController = _api.getStorage()!;
    } catch (e) {
      log("Database Connection Error From LocalStorage: $e");
      rethrow;
    }
  }

  Future<EventType?> listenToStorage(Node node) async {
    LocalStorageListener l = LocalStorageListener();
    SearchCriteria s = SearchCriteria(searchPath: ":");
    //listen to dummy storage
    _storageController.registerChangeListener(l, s);
    Node _node = await node.deepClone();
    //
    List<Event> e = await _storageController
        .update(_node)
        .then((_) async => await l.events);

    log("Length of the Event ${e.length}");
    if (e.length > 0) {
      for (Event event in e) {
        if (event.type == EventType.update) return event.type;
        log("EventType: ${event.type}");
      }
    }
    return null;
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

//Todo
// registered storageListener
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

  @override
  void gotStorageChange(EventType event, Node? oldNode, Node? newNode) {
    Event e = Event(event, oldNode, newNode);
    events.add(e);
    // ignore: avoid_print
    print('got event ${e.toString()}');
  }

  Future<List<Event>> getNumEvents(int num, [int timeout = 2000]) async {
    int start = DateTime.now().millisecondsSinceEpoch;
    List<Event> ret = await Future.doWhile(() =>
            events.length < num &&
            start + 1000 * timeout > DateTime.now().millisecondsSinceEpoch)
        .then((value) => events);
    if (events.length < num) {
      throw TimeoutException('Timeout reached while waiting for $num events');
    }
    return ret;
  }
}
