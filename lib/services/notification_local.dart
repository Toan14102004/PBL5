// import 'dart:developer';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../main.dart';
// import '../screens/map_screen.dart';
//
// class NotificationLocalService {
//   static final _notifications = FlutterLocalNotificationsPlugin();
//
//   static Future<void> init() async {
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const iosSettings = DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );
//
//     const initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await _notifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         final payload = response.payload;
//         if (payload != null && payload.startsWith('fall:')) {
//           final parts = payload.split(':'); // payload = "fall:lat:long"
//           final lat = double.tryParse(parts[1]);
//           final long = double.tryParse(parts[2]);
//           if (lat != null && long != null) {
//             navigatorKey.currentState?.push(
//               MaterialPageRoute(
//                 builder: (_) => MapScreen(initialPosition: LatLng(lat, long)),
//               ),
//             );
//           }
//         }
//       },
//     );
//   }
//
//   static Future<void> requestPermission() async {
//     // Android
//     final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await androidImplementation?.requestNotificationsPermission();
//
//     // iOS
//     final iosImplementation = _notifications.resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>();
//     await iosImplementation?.requestPermissions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//   static Future show(String title, String body, {String? payload}) async {
//     const androidDetails = AndroidNotificationDetails(
//       'channelId',
//       'FireAlert',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     const platformDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     const details = NotificationDetails(android: androidDetails);
//     await _notifications.show(0, title, body, details, payload: payload);
//   }
//
//   static void getDeviceToken() async {
//     String? token = await FirebaseMessaging.instance.getToken();
//     log("Device Token: $token");
//   }
// }


import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../main.dart';
import '../screens/map_screen.dart';

class NotificationLocalService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && payload.startsWith('fall:')) {
          final parts = payload.split(':'); // payload = "fall:lat:long"
          final lat = double.tryParse(parts[1]);
          final long = double.tryParse(parts[2]);
          if (lat != null && long != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => MapScreen(initialPosition: LatLng(lat, long)),
              ),
            );
          }
        }
      },
    );
  }

  static Future<void> requestPermission() async {
    // 🔹 Firebase Messaging permission
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔹 Android 13+
    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();

    // 🔹 iOS
    final iosImplementation = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> show(String title, String body, {String? payload}) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'FireAlert',
      channelDescription: 'Thông báo từ hệ thống',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 🔹 Gán ID động để tránh ghi đè
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await _notifications.show(
      id,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  static void getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    log("Device Token: $token");
  }
}
