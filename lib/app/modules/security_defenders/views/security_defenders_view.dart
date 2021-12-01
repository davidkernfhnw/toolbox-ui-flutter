import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/modules/security_defenders/views/widgets/defenders_card.dart';
import 'package:geiger_toolbox/app/routes/app_routes.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_dropdown_country.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_dropdown_partners.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_text_field.dart';
import 'package:geiger_toolbox/app/shared_widgets/side_menu.dart';

//import 'package:get/get.dart';

class SecurityDefendersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text(Routes.SECURITY_DEFENDERS_DISPLAY_NAME),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropDownCountry(
                          listItems: ["switzerland"],
                          hintText: "Select Country",
                          titleText: "Country",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomDropDownFlutter(
                          listItems: [],
                          hintText: '',
                          titleText: "Association",
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                            label: "",
                            hintText: "Search region",
                            textEditingController: TextEditingController()),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: Icon(
                          Icons.search,
                          size: 35,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: ListTile.divideTiles(
                    //          <-- ListTile.divideTiles
                    context: context,
                    tiles: [
                      DefendersCard(
                        location: 'Braunwald',
                        job: 'Hairdresser',
                        name: 'Alexandra Baumgartner',
                      ),
                      DefendersCard(
                        location: 'Brugg',
                        job: 'Hairdresser',
                        name: 'Daniel John',
                      ),
                      DefendersCard(
                        location: 'Brugg',
                        job: 'Hairdresser',
                        name: 'Daniel John',
                      ),
                      DefendersCard(
                        location: 'Brugg',
                        job: 'Hairdresser',
                        name: 'Daniel John',
                      ),
                      DefendersCard(
                        location: 'Brugg',
                        job: 'Hairdresser',
                        name: 'Daniel John',
                      ),
                      DefendersCard(
                        location: 'Brugg',
                        job: 'Hairdresser',
                        name: 'Daniel John',
                      ),
                    ]).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
