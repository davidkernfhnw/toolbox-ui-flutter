import 'package:flutter/material.dart';

import 'package:geiger_toolbox/app/shared_widgets/empty_space_card.dart';

class EditDataView extends StatelessWidget {
  const EditDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          EmptySpaceCard(
            size: size.width,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(onPressed: null, child: Text("Reset")),
              ElevatedButton(onPressed: null, child: Text("Import")),
              ElevatedButton(onPressed: null, child: Text("Export")),
            ],
          )
        ],
      ),
    );
  }
}
