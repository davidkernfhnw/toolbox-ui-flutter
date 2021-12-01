import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/shared_widgets/empty_space_card.dart';
import 'package:geiger_toolbox/app/util/style.dart';

import 'package:get/get.dart';

import '../controllers/terms_and_conditions_controller.dart';

class TermsAndConditionsView extends StatelessWidget {
  TermsAndConditionsView({Key? key}) : super(key: key);

  // double getResponsiveHeight(BuildContext context) {
  //   var temp = MediaQuery.of(context).size.height - 60 * 8;
  //   if (temp < 0) return 0;
  //   return temp;
  // }

  //initial controller
  final TermsAndConditionsController _controller =
      TermsAndConditionsController.to;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              EmptySpaceCard(
                size: size.width,
                child: ListView(
                  children: [
                    ListTile(
                      leading: Checkbox(
                        value: _controller.ageCompliant.value,
                        onChanged: (bool? value) {
                          _controller.ageCompliant.value = value!;
                        },
                      ),
                      title: boldText('I am at least 16 years old.'),
                    ),
                    ListTile(
                      leading: Checkbox(
                        value: _controller.signedConsent.value,
                        onChanged: (bool? value) {
                          _controller.signedConsent.value = value!;
                        },
                      ),
                      title: boldText('I have signed a consent form.'),
                      subtitle:
                          greyText('https://cloud.cyber-geiger.eu/f/25282'),
                    ),
                    ListTile(
                      leading: Checkbox(
                        value: _controller.agreedPrivacy.value,
                        onChanged: (bool? value) {
                          _controller.agreedPrivacy.value = value!;
                        },
                      ),
                      title: boldText(
                          'I have read and agree with the Privacy Policy of the GEIGER Toolbox.'),
                      subtitle:
                          greyText('https://cloud.cyber-geiger.eu/f/25282'),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'In order to use the toolbox all terms above have to be accepted',
                        style: TextStyle(
                            color: _controller.error.value
                                ? Colors.red
                                : Colors.grey),
                      ),
                    ),
                    ListTile(
                      title: ElevatedButton(
                        onPressed: () {
                          _controller.agreed();
                        },
                        child: Text("Continue"),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
