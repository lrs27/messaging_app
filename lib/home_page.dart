import 'package:flutter/material.dart';
import 'package:messaging_app/fcm_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();
  String statusText = 'Waiting for a cloud message';
  String imagePath = 'lib/assets/images/default.png';

  @override
  void initState() {
    super.initState();

    // 2. Get the FCM token for this device
    FirebaseMessaging.instance.getToken().then((token) {
      debugPrint('FCM token: $token');
    });

    // 3. Initialize your FCM service listeners
    _fcmService.initialize(
      onData: (message) {
        setState(() {
          statusText = message.notification?.title ?? 'Payload received';
          imagePath =
              'lib/assets/images/${message.data['asset'] ?? 'default'}.png';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messaging App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath),
            const SizedBox(height: 20),
            Text(statusText),
          ],
        ),
      ),
    );
  }
}
