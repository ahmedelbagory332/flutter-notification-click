import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_example/screens/settings.dart';

import '../notification/notification.dart';
import '../notification/notification_messages.dart';

class MyHomePage extends StatefulWidget {
   MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

@override
  void initState() {
    super.initState();

    getDeviceToken().then((value) {
      debugPrint("fcm token: $value");
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message?.data != null){
        debugPrint('notification clicked from termination : ${message!.data}');

        Data notificationMessage = Data.fromJson(message.data);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SettingsPage(
                notificationTitle: notificationMessage.title,
              )),
        );

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           ElevatedButton(onPressed: (){
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) =>  SettingsPage()),
             );
           }, child: const Text("Settings Screen"))
          ],
        ),
      ),
    );
  }
}
