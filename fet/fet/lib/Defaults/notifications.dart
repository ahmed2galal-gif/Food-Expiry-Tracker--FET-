import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../app.dart';

late NotificationsEngine notificationEngine;

class NotificationsEngine {
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  static const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    appName,
    appName,
    channelDescription: 'App notifications',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  Future<void> showNotification(
      int id, String title, String body, String payload) async {
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await FlutterLocalNotificationsPlugin()
        .show(id, title, body, platformChannelSpecifics, payload: payload);
  }

  Future initNotifications(BuildContext context) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Egypt"));
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) async {
      handleNotificationClick(context, json.decode(response.payload ?? "{}"));
    });

    await AndroidFlutterLocalNotificationsPlugin()
        .requestExactAlarmsPermission();

    await AndroidFlutterLocalNotificationsPlugin()
        .requestNotificationsPermission();

    NotificationAppLaunchDetails? details =
        await FlutterLocalNotificationsPlugin()
            .getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      handleNotificationClick(
          context, json.decode(details?.notificationResponse?.payload ?? "{}"));
    }
  }

  Future handleNotificationClick(
      BuildContext context, Map<String, dynamic> payload) async {
    switch (payload["type"]) {
      case "recipes":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Recipes(
                  food: FoodModel.fromName(payload["name"]),
                )));

        break;
      case "donation":
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Donations()));

        break;
      default:
    }
  }

  Future cancelNotification(int hashcode) async {
    await FlutterLocalNotificationsPlugin().cancel(hashcode);
  }

  Future get cancelAllNotifications async {
    await FlutterLocalNotificationsPlugin().cancelAll();
  }

  Future showScheduledNotification(int id, DateTime date, String title,
      String body, Map<String, dynamic> payload) async {
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    var timeZone = tz.TZDateTime.from(date, tz.local);

    print(timeZone);

    if (timeZone.isAfter(tz.TZDateTime.now(tz.local))) {
      await FlutterLocalNotificationsPlugin().zonedSchedule(
        id,
        title,
        body,
        timeZone,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: json.encode(payload),
      );
    }
  }
}
