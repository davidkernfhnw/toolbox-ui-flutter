import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_text_field.dart';

class EditDataView extends StatelessWidget {
  const EditDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: size.width,
                  child: Text(""),
                ),
              ),
            ),
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
