//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geiger_toolbox/app/util/style.dart';

class DefendersCard extends StatelessWidget {
  const DefendersCard(
      {Key? key,
      required this.name,
      required this.job,
      required this.location,
      this.imagePath,
      this.onPressed})
      : super(key: key);

  final String name;
  final String job;
  final String location;
  final String? imagePath;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          boldText(name),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 30,
                child: CircleAvatar(
                  radius: 29,
                  backgroundImage: AssetImage(
                      imagePath ?? "assets/images/defender_icon.png"),
                  // child: Icon(
                  //   Icons.person_outlined,
                  //   size: 40,
                  // ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.card_travel,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10),
                        greyText(job),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person_pin_circle_outlined,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10),
                        greyText(location),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onPressed ?? null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.email_outlined,
                      ),
                      Text("contact")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
