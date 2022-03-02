import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/data_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/empty_space_card.dart';
import 'package:geiger_toolbox/app/util/style.dart';
import 'package:get/get.dart';

import '../../controllers/data_protection_controller.dart';

class DataView extends StatelessWidget {
  DataView({Key? key}) : super(key: key);
  final DataController controller = DataController.instance;
  final DataProtectionController _dataProtectionController =
      DataProtectionController.instance;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          EmptySpaceCard(
            size: size.width,
            child: FutureBuilder<String>(
                future: controller.showRawData(),
                initialData: "Loading Data",
                builder: (context, snapshot) {
                  return SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _dataProtectionController.getDataAccess
                        ? greyText(snapshot.data.toString())
                        : Center(
                            child: Text(
                              "allow-data-access-process".tr,
                            style: TextStyle(color: Colors.red),
                          )),
                  ));
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //OutlinedButton(onPressed: null, child: Text("Reset")),
              //ElevatedButton(onPressed: null, child: Text("Import")),
              ElevatedButton(
                  onPressed: _dataProtectionController.getDataAccess
                      ? () {
                          controller.makeJsonFile();
                        }
                      : null,
                  child: Text("export".tr)),
            ],
          )
        ],
      ),
    );
  }
}
