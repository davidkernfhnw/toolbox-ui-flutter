import 'dart:convert';

import 'package:geiger_localstorage/geiger_localstorage.dart';
import 'package:geiger_toolbox/app/services/localStorage/local_storage_controller.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/geiger_data.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/implementation/impl_user_service.dart';
import 'package:get/get.dart';

class QrCodeController extends GetxController {
  static final QrCodeController instance = Get.find<QrCodeController>();

  final LocalStorageController localStorageInstance =
      LocalStorageController.instance;
  late final StorageController _storageController;

  late GeigerData _geigerUtilityData;

  var data = "".obs;

  void _storeDataAsQrCode({String agreementType: "both"}) async {
    _geigerUtilityData = GeigerData(_storageController);
    String publicKey = await _geigerUtilityData.getPublicKey;
    UserService userService = UserService(_storageController);
    String userId = await userService.getUserId;
    String body = jsonEncode(<String, dynamic>{
      'agreement': agreementType,
      'publicKey': '${publicKey}',
      'userId': '${userId}',
    });
    data.value = body;
    //User? user = await userService.getUserInfo;
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
    _storeDataAsQrCode();
    super.onInit();
  }
}
