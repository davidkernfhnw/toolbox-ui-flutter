import 'package:geiger_api/geiger_api.dart';
import 'package:get/get.dart';

class GeigerApiConnector extends GetxController {
  //instance of GeigerApiConnector
  static GeigerApiConnector to = Get.find<GeigerApiConnector>();

  late GeigerApi _geigerApiMaster;

  GeigerApi get getGeigerApiMaster {
    return _geigerApiMaster;
  }

  Future<void> initGeigerApi() async {
    flushGeigerApiCache();
    //*****************************************master**********************
    _geigerApiMaster =
        (await getGeigerApi("", GeigerApi.masterId, Declaration.doShareData))!;
    //clear existing state
    await _geigerApiMaster.zapState();
  }

  //Todo
  // registered plugin
  //listen to plugin
}
