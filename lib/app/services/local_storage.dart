//import 'dart:developer';

import 'dart:async';
import 'dart:developer';

import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:get/get.dart' as getx;
import 'package:geiger_api/geiger_api.dart';

class LocalStorageController extends getx.GetxController {
  //instance
  static LocalStorageController to = getx.Get.find();

  late StorageController storageControllerDummy;
  late StorageController storageControllerUi;

  // Future<StorageController?> initLocalStorage() async {
  //   try {
  //     GeigerDummy g = GeigerDummy();
  //
  //     GeigerApi api = await g.initGeigerApi();
  //     ;
  //     return api.getStorage();
  //   } catch (e) {
  //     log("Database Connection Error From LocalStorage: $e");
  //     rethrow;
  //   }
  // }
  Future<void> initLocalStorageDummy() async {
    try {
      GeigerDummy g = GeigerDummy();

      GeigerApi api = await g.initGeigerApi();
      storageControllerDummy = api.getStorage()!;
      //storageController = (await g.getStorageController())!;
    } catch (e) {
      log("Database Connection Error From LocalStorage: $e");
      rethrow;
    }
  }

  Future<GeigerApi> initGeigerApiUi() async {
    //flushGeigerApiCache();
    //*****************************************master**********************
    GeigerApi localMaster =
        (await getGeigerApi("", GeigerApi.masterId, Declaration.doShareData))!;
    //clear existing state
    //await localMaster.zapState();
    return localMaster;
  }

  Future<StorageController?> initLocalStorageUI() async {
    try {
      GeigerApi api = await initGeigerApiUi();
      storageControllerUi = api.getStorage()!;
      //storageController = (await g.getStorageController())!;
    } catch (e) {
      log("Database Connection Error From LocalStorage: $e");
      rethrow;
    }
  }

  Future<List<Event>> listenToStorage(Node node) async {
    LocalStorageListener l = LocalStorageListener();
    SearchCriteria s = SearchCriteria(searchPath: ":");
    //listen to dummy storage
    storageControllerDummy.registerChangeListener(l, s);
    Node _node = await node.deepClone();
    //
    List<Event> e = await storageControllerDummy
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
  void onInit() async {
    //storageController = (await _initLocalStorage())!;
    super.onInit();
    // await _initLocalStorage();
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
