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
  late LocalStorageListener _localStorageListener;

  StorageController get getStorageController {
    return _storageController;
  }

  LocalStorageListener get getLocalStorageListener {
    try {
      return _localStorageListener;
    } catch (e) {
      log("LocalStorageListener has not be initialized \n$e");
      rethrow;
    }
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

  //called this first
  // 3 node path
  Future<void> registerListener(Node node, String path,
      [String? searchKey]) async {
    _localStorageListener = LocalStorageListener();
    SearchCriteria s = SearchCriteria(searchPath: path);
    if (searchKey != null) {
      s.set(Field.key, searchKey);
    }
    await _storageController.registerChangeListener(_localStorageListener, s);
  }

  //called this after
  //one Node path
  Future<bool> triggerListener(Node node, String path, String searchKey) async {
    SearchCriteria s = SearchCriteria(searchPath: path);
    s.set(Field.key, searchKey);
    bool e = await s.evaluate(node);
    log("Triggerlistener => $e");
    return e;
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
  Future<void> gotStorageChange(
      EventType event, Node? oldNode, Node? newNode) async {
    Event e = Event(event, oldNode, newNode);
    events.add(e);
    // ignore: avoid_print
    print('got event for ui ${e.toString()}');
  }

  //called this in the ui
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
