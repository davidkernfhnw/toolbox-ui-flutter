import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/tools/views/widgets/tools_card.dart';
import 'package:geiger_toolbox/app/shared_widgets/empty_space_card.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';

class ToolsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('ToolsView'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              EmptySpaceCard(
                  size: size.width,
                  child: ListView(
                    children: ListTile.divideTiles(
                        //          <-- ListTile.divideTiles
                        context: context,
                        tiles: [
                          Tools_card(),
                          Tools_card(),
                          Tools_card(),
                        ]).toList(),
                  )),
              ElevatedButton(onPressed: null, child: Text("Add Tool"))
            ],
          )),
    );
  }
}
