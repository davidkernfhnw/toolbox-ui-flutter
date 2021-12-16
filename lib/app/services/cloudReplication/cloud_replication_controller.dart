import 'package:get/get.dart';
import 'package:cloud_replication_package/cloud_replication_package.dart';

class CloudReplicationController extends GetxController {
  static final CloudReplicationController instance =
      Get.find<CloudReplicationController>();

  ReplicationController get getReplicationController {
    return _controller;
  }

  late final ReplicationController _controller;

  Future<void> initialReplication() async {
    _controller = ReplicationService();

    await _controller.initGeigerStorage();
    await _controller.geigerReplication();
    await _controller.endGeigerStorage();
  }

  @override
  void onInit() async {
    super.onInit();
  }
}
