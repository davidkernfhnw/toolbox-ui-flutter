import 'package:flutter/material.dart';

TabBar buildTabBar() {
  return const TabBar(
    tabs: <Widget>[
      Tab(
        icon: Icon(
          Icons.person,
        ),
        text: "User",
      ),
      Tab(
        icon: Icon(
          Icons.phone_android_rounded,
        ),
        text: "Device Risk",
      ),
    ],
  );
}
