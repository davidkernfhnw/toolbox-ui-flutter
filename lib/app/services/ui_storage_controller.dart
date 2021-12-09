//import 'dart:developer';

import 'dart:async';
import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:get/get.dart' as getx;
import 'package:geiger_api/geiger_api.dart';

class UiStorageController extends getx.GetxController {
  //instance
  static UiStorageController instance = getx.Get.find<UiStorageController>();

  late final StorageController _storageControllerUi;

  Future<void> initLocalStorageUI() async {
    log("initLocalStorageUi method has been called");
    try {
      log("calling _initGeigerApi");
      GeigerApi api = await _initGeigerApiUi();
      _storageControllerUi = await api.getStorage()!;
      log("got $_storageControllerUi for Ui");
      //storageController = (await g.getStorageController())!;
    } catch (e) {
      log("Database Connection Error From LocalStorageUI:");
      rethrow;
    }
  }

  Future<GeigerApi> _initGeigerApiUi() async {
    //flushGeigerApiCache();
    //*****************************************master**********************
    log("_initGeigerApiUi method has been called");
    try {
      GeigerApi localMaster = (await getGeigerApi(
          "", GeigerApi.masterId, Declaration.doShareData))!;
      //clear existing state
      //await localMaster.zapState();
      log("got $localMaster");
      return localMaster;
    } on StorageException {
      throw StorageException("Error from GeigerApi");
    }
  }

  Future<List<Event>> listenToStorage(Node node) async {
    LocalStorageListener l = LocalStorageListener();
    SearchCriteria s = SearchCriteria(searchPath: ":");
    //listen to dummy storage
    _storageControllerUi.registerChangeListener(l, s);
    Node _node = await node.deepClone();
    //
    List<Event> e = await _storageControllerUi
        .update(_node)
        .then((_) async => await l.events);

    log("Length of the Event ${e.length}");
    if (e.length > 0) {
      for (Event event in e) {
        log("EventType: ${event.type}");
      }
    }

    return e;
  }

  @override
  void onInit() {
    super.onInit();
  }

  // @override
  // void onInit() async {
  //   super.onInit();
  //   //in uIGeiger
  //   //Future.delayed(Duration(seconds: 1));
  //   //await _initLocalStorageUI();
  // }

  // @override
  // void onReady() async {
  //   //storageController = (await _initLocalStorage())!;
  //   super.onReady();
  //
  //   // await _initLocalStorage();
  //   log("READY CALLED");
  // }

//helpers
  Future<void> storeNewUser(bool value) async {
    try {
      Node node = await _storageControllerUi.get(":Local");
      await node.addOrUpdateValue(NodeValueImpl("newUser", value.toString()));
      //when creating my data
      // add this to avoid error
      // since on package are also getStorage
      await ExtendedTimestamp.initializeTimestamp(_storageControllerUi);
      await _storageControllerUi.addOrUpdate(node);
      print("storeNewUser method: $node");
    } catch (e, s) {
      StorageException("Storage Error: $e", s);
    }
  }

  Future<void> upNewUser(bool value) async {
    try {
      Node node = await _storageControllerUi.get(":Local");
      //Note: If nodeValue is already exist used updateValue() to update it
      await node.updateValue(NodeValueImpl("newUser", value.toString()));
      //when creating my data
      // add this to avoid error
      // since on package are also getStorage
      await ExtendedTimestamp.initializeTimestamp(_storageControllerUi);
      await _storageControllerUi.addOrUpdate(node);
      print("storeNewUser method: $node");
    } catch (e, s) {
      StorageException("Storage Error: $e", s);
    }
  }

  Future<bool> isNewUser() async {
    try {
      NodeValue? nodeValue =
          await _storageControllerUi.getValue(":Local", "newUser");
      String newUser = nodeValue!.value;
      bool isNewUser = newUser.parseBool();
      print("isNewUser method: $newUser");
      if (isNewUser == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Error from storageControllerUi");
      return false;
    }
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
  void gotStorageChange(EventType event, Node? oldNode, Node? newNode) {
    Event e = Event(event, oldNode, newNode);
    events.add(e);
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

extension BoolParsing on String {
  bool parseBool() {
    if (this.toLowerCase() == 'true') {
      return true;
    } else if (this.toLowerCase() == 'false') {
      return false;
    }

    throw '"$this" can not be parsed to boolean.';
  }
}
