import 'package:get/get.dart';
import 'package:cloud_replication_package/cloud_replication_package.dart';

class CloudReplicationController {
  // static final CloudReplicationController instance =
  //     Get.find<CloudReplicationController>();

  static Future<void> initialReplication() async {
    ReplicationController controller = ReplicationService();

    await controller.initGeigerStorage();
    //Future.delayed(Duration(seconds: 3));
    await controller.geigerReplication();

    //await controller.endGeigerStorage();
  }
}
