
import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_example/main.dart';
import 'package:notification_example/notification/notification_messages.dart';
import 'package:notification_example/screens/settings.dart';


notificationInitialization() async {


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  const DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');


  InitializationSettings initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onSelectNotification,
    onDidReceiveBackgroundNotificationResponse: onSelectNotification,
  );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    Data data = Data.fromJson(message.data);
    debugPrint("notification clicked from background ${message.data}");
    Navigator.push(rootNavigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>SettingsPage(notificationTitle: data.title,)));

  });

}
void onSelectNotification(NotificationResponse details) {
  if(details.payload !=null){
    var notification = json.decode(details.payload!);
    debugPrint("notification clicked $notification");
   Data data = Data.fromJson(notification);
   Navigator.push(rootNavigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>SettingsPage(notificationTitle: data.title,)));

  }
}


@pragma('vm:entry-point')
Future<void> notificationBackgroundHandler(RemoteMessage message) async{
  debugPrint("notification from background from data ${message.data}");
  debugPrint("notification from background from notification ${message.notification}");
}

@pragma('vm:entry-point')
notificationForegroundHandler(){
  FirebaseMessaging.onMessage.listen((message) {
    if(message.data.isNotEmpty){
      debugPrint("notification from foreground from data ${message.data}");
      Data notification = Data.fromJson(message.data);
      showNotification(notification.title!, notification.message!, message.data);
    }else{
      debugPrint("notification from foreground from data ${message.notification}");
    }
  });
}


showNotification(String title , String body,Map<String ,dynamic> data) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      "message notification", "Messages Notifications",
      channelDescription: "show message to user",
      channelShowBadge: false,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      autoCancel: false);

  // iOS Notification Details
  const DarwinNotificationDetails iosPlatformChannelSpecifics = DarwinNotificationDetails(
    presentAlert: true, // Show an alert when the notification is delivered to the device
    presentBadge: true, // Apply a badge to the app icon when the notification is delivered
    presentSound: true, // Play a sound when the notification is delivered
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  NotificationDetails notificationDetails =
      const NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics
      );

  await flutterLocalNotificationsPlugin.show(Random().nextInt(1000000), title, body, notificationDetails,payload:json.encode(data) );

}

Future<String?> getDeviceToken()  async{
  return await FirebaseMessaging.instance.getToken();
}
