import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/shared_widgets/empty_space_card.dart';
import 'package:geiger_toolbox/app/shared_widgets/form_field/custom_radio_list_tile.dart';
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
      TermsAndConditionsController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions"),
        elevation: 1,
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmptySpaceCard(
                child: ListView(
                  children: [
                    CheckboxListTile(
                      onChanged: (bool? value) {
                        _controller.ageCompliant.value = value!;
                      },
                      value: _controller.ageCompliant.value,
                      title: boldText('I am at least 16 years old.'),
                    ),
                    CheckboxListTile(
                      value: _controller.signedConsent.value,
                      onChanged: (bool? value) {
                        _controller.signedConsent.value = value!;
                      },
                      title: Text('I have signed a consent form.'),
                      subtitle: GestureDetector(
                          onTap: _controller.launchConsentUrl,
                          child: Text(
                            CONSENT_FORM,
                            style: TextStyle(color: Colors.blue),
                          )),
                    ),
                    CheckboxListTile(
                      value: _controller.agreedPrivacy.value,
                      onChanged: (bool? value) {
                        _controller.agreedPrivacy.value = value!;
                      },
                      title: Text(
                        'I have read and agree with the Privacy Policy of the GEIGER Toolbox.',
                      ),
                      subtitle: GestureDetector(
                        onTap: _controller.launchPrivacyUrl,
                        child: Text(
                          PRIVACY_POLICY,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: boldText("Your company does..."),
                        ),
                        CustomLabeledRadio(
                          label: "only consume digital products",
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          groupValue: _controller.isRadioSelected.value,
                          value: 0,
                          onChanged: (int newValue) {
                            _controller.isRadioSelected.value = newValue;
                          },
                        ),
                        CustomLabeledRadio(
                          label: "sell digital products but not develop them",
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          groupValue: _controller.isRadioSelected.value,
                          value: 1,
                          onChanged: (int newValue) {
                            _controller.isRadioSelected.value = newValue;
                          },
                        ),
                        CustomLabeledRadio(
                          label: " develop and sell digital products itself",
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          groupValue: _controller.isRadioSelected.value,
                          value: 2,
                          onChanged: (int newValue) {
                            _controller.isRadioSelected.value = newValue;
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
              Text(
                'In order to use the toolbox all terms above have to be accepted',
                style: TextStyle(
                    color:
                        _controller.errorMsg.value ? Colors.red : Colors.grey),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  _controller.acceptTerms();
                },
                child: Text("Continue"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
