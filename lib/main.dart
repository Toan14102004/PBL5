// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'screens/home_screen.dart';  // Đảm bảo bạn đã import đúng màn hình HomeScreen.
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Health App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }
//
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_app_ui/screens/map_screen.dart';
import 'package:health_app_ui/services/notification_local.dart';
import 'screens/home_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('🔕 [Background] Received a message: ${message.messageId}');
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationLocalService.init();
  await NotificationLocalService.requestPermission();
  NotificationLocalService.getDeviceToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('📩 [Foreground] Message received!');
    NotificationLocalService.show(
      message.notification?.title ?? '',
      message.notification?.body ?? '',
    );
    log('Data: ${message.data}');
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');

    if (message.data.isNotEmpty) {
      final data = message.data;
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => MapScreen(initialPosition: LatLng(
          double.parse(data['lat']),
          double.parse(data['long']),
        ))),
      );
    }
  });
  // App ở background, user click noti để mở app
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log('👆 [onMessageOpenedApp] Notification clicked!');
    log('Data: ${message.data}');

    if (message.data.isNotEmpty) {
      final data = message.data;
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => MapScreen(initialPosition: LatLng(
          double.parse(data['lat']),
          double.parse(data['long']),
        ))),
      );
    }
  });
  // runApp(const MyApp());
  runApp(MaterialApp(navigatorKey: navigatorKey, home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeScreen(userId: 'user_1029357990');
  }
}
