import 'dart:developer';

import 'package:cloud_replication_package/cloud_replication_package.dart';
import 'package:get/get.dart';

class CloudReplicationController extends GetxController {
  static final CloudReplicationController instance =
      Get.find<CloudReplicationController>();

  ReplicationController get getReplicationController {
    return _controller;
  }

  late final ReplicationController _controller;

  void _initialReplicationController() {
    _controller = ReplicationService();
  }

  Future<void> initialReplication() async {
    try {
      await _controller.initGeigerStorage();
      bool checkReplication = await _controller.checkReplication();
      if (checkReplication == false) {
        await _controller.geigerReplication(
            _controller.deleteHandler,
            _controller.createHandler,
            _controller.renameHanlder,
            _controller.updateHanlder);
        await _controller.endGeigerStorage();
      }
    } catch (e) {
      log("Failed to initialReplication");
    }
  }

  @override
  void onInit() async {
    _initialReplicationController();
    super.onInit();
  }
}
