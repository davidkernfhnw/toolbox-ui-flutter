import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotificationController extends GetxController {
  //instance
  static final LocalNotificationController instance =
      Get.find<LocalNotificationController>();

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  FlutterLocalNotificationsPlugin get getFlutterLocalNotificationsPlugin {
    return _flutterLocalNotificationsPlugin;
  }

  void _initNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (Platform.isMacOS) {
      // ignore: unused_local_variable
      final bool? result = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    if (Platform.isIOS) {}
  }

  Future<void> notification(String title, String message) async {
    if (Platform.isMacOS || Platform.isAndroid || Platform.isIOS) {
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('Channel ID', 'Channel title',
              channelDescription: 'channel body',
              priority: Priority.high,
              importance: Importance.max,
              ticker: 'test');

      IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
      MacOSNotificationDetails macOSNotificationDetails =
          MacOSNotificationDetails();

      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: iosNotificationDetails,
          macOS: macOSNotificationDetails);
      await _flutterLocalNotificationsPlugin.show(
          0, title, message, notificationDetails);
    }
  }

  @override
  void onInit() {
    _initNotifications();
    super.onInit();
  }
}
