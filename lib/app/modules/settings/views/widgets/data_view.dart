import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/settings/controllers/data_controller.dart';
import 'package:geiger_toolbox/app/shared_widgets/empty_space_card.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class DataView extends StatelessWidget {
  final DataController controller;
  const DataView({Key? key, required this.controller}) : super(key: key);
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
                    child: greyText(
                      jsonEncode(snapshot.data),
                    ),
                  ));
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //OutlinedButton(onPressed: null, child: Text("Reset")),
              //ElevatedButton(onPressed: null, child: Text("Import")),
              ElevatedButton(
                  onPressed: () {
                    controller.makeJsonFile();
                  },
                  child: Text("Export")),
            ],
          )
        ],
      ),
    );
  }
}
