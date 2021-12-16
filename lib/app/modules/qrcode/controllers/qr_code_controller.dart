import 'dart:convert';

import 'package:geiger_toolbox/app/data/model/user.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/impl_utility_data.dart';
import 'package:geiger_toolbox/app/services/localStorage/localServices/user_service.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:get/get.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

class QrCodeController extends GetxController {
  static final QrCodeController instance = Get.find<QrCodeController>();

  final LocalStorageController localStorageInstance =
      LocalStorageController.instance;
  late final StorageController _storageController;

  late ImplUtilityData _utilityData;

  var data = "".obs;

  void _getData({String agreementType: "in"}) async {
    _utilityData = ImplUtilityData(_storageController);
    String publicKey = await _utilityData.getPublicKey;
    UserService userService = UserService(_storageController);
    String userId = await userService.getUserId;
    String body = jsonEncode(<String, dynamic>{
      'agreement': "in",
      'publicKey': '${publicKey}',
      'userId': '${userId}',
    });
    data.value = body;
    User? user = await userService.getUserInfo;
    // if (user != null) {
    //   if (user.supervisor == true) {
    //     String body = jsonEncode(<String, dynamic>{
    //       'agreement': "in",
    //       'publicKey': '${publicKey}',
    //       'userId': '${user.userId}',
    //     });
    //     data.value = body;
    //   } else {
    //     String body = jsonEncode(<String, dynamic>{
    //       'agreement': agreementType,
    //       'publicKey': '${publicKey}',
    //       'userId': '${user.userId}',
    //     });
    //     data.value = body;
    //   }
    // }
  }

  @override
  void onInit() {
    _storageController = localStorageInstance.getStorageController;
    _getData();
    super.onInit();
  }
}
