import 'package:flutter/material.dart';


class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key, this.notificationTitle}) : super(key: key);

   String? notificationTitle;

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
            Text(notificationTitle??"No data yet"),
          ],
        ),
      ),
    );
  }
}
