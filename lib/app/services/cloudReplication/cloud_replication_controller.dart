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

  void _initialReplicationController() async {
    _controller = ReplicationService();
    await _controller.initGeigerStorage();
  }

  Future<bool> initialReplication() async {
    try {
      await _controller.geigerReplication(
          _controller.deleteHandler,
          _controller.createHandler,
          _controller.renameHanlder,
          _controller.updateHanlder);
      await _controller.endGeigerStorage();
      //success
      return true;
    } catch (e) {
      log("Failed to initialReplication $e");
      return false;
    }
  }

  Future<bool> checkReplication() async {
    bool checkReplication = await _controller.checkReplication();
    if (checkReplication == false) {
      //do replication
      return true;
    } else {
      //replication has be done before
      return false;
    }
  }

  @override
  void onInit() {
    _initialReplicationController();
    super.onInit();
  }
}
