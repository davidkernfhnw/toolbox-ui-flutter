import 'package:geiger_api/geiger_api.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart'
    as geigerLocalStorage;
import 'package:get/get.dart';

class GeigerApiConnector extends GetxController {
  //instance of GeigerApiConnector
  static GeigerApiConnector to = Get.find<GeigerApiConnector>();

  late GeigerApi _localMaster;

  GeigerApi get getLocalMaster {
    return _localMaster;
  }

  /// initialize this method before the start of the app
  Future<void> initLocalMasterPlugin() async {
    flushGeigerApiCache();
    //*****************************************master**********************
    _localMaster =
        (await getGeigerApi("", GeigerApi.masterId, Declaration.doShareData))!;
    //clear existing state
    await _localMaster.zapState();
  }

  Future<void> registerLocalMasterListener() async {
    List<MessageType> allEvents = MessageType.getAllValues();
    EventListener localMasterListener = EventListener('master');
    await _localMaster.registerListener(allEvents, localMasterListener);
  }

  Future<void> initGeigerIndicatorPlugin() async {}
  Future<void> registerGeigerIndicatorListener() async {}

  //Todo
  // registered plugin
  //listen to plugin
}

class EventListener implements PluginListener {
  List<Message> events = [];

  final String _id;

  EventListener(this._id);

  @override
  void pluginEvent(GeigerUrl? url, Message msg) {
    events.add(msg);
    print(
        '## SimpleEventListener "$_id" received event ${msg.type} it currently has: ${events.length.toString()} events');
  }

  List<Message> getEvents() {
    return events;
  }

  @override
  String toString() {
    String ret = '';
    ret += 'EventListener "$_id" contains {\r\n';
    getEvents().forEach((element) {
      ret += '  ${element.toString()}\r\n';
    });
    ret += '}\r\n';
    return ret;
  }
}

class Event {
  final geigerLocalStorage.EventType _event;
  final Node? _old;
  final Node? _new;

  Event(this._event, this._old, this._new);

  geigerLocalStorage.EventType get type => _event;

  Node? get oldNode => _old;

  Node? get newNode => _new;

  @override
  String toString() {
    return '${type.toString()} ${oldNode.toString()}=>${newNode.toString()}';
  }
}
