import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class ToolCard extends StatelessWidget {
  const ToolCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.ac_unit),
      title: boldText("CySec"),
      subtitle: greyText("FHNW"),
      trailing: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.grey,
        child: CircleAvatar(
          child: InkWell(
            onTap: () {
              log("working");
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
