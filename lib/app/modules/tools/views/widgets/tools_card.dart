import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class ToolCard extends StatelessWidget {
  final String toolId;
  final String appName;
  final String companyName;
  final bool installed;
  ToolCard({
    Key? key,
    required this.toolId,
    required this.appName,
    required this.companyName,
    required this.installed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.ac_unit),
      title: boldText(appName),
      subtitle: greyText(companyName),
      trailing: !installed
          ? ElevatedButton(onPressed: null, child: Text("Install"))
          : CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                child: InkWell(
                  onTap: () {
                    log(toolId);
                  },
                  child: Icon(
                    Icons.remove,
                    color: Colors.grey,
                  ),
                ),
                radius: 12,
              ),
            ),
    );
  }
}
