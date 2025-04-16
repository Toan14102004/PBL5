import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
// import 'screens/Profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      // home: HomeScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'screens/activity_screen.dart';
//
// void main() {
//   runApp(const HealthApp());
// }
//
// class HealthApp extends StatelessWidget {
//   const HealthApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const ActivityScreen(),
//     );
//   }
// }



//
// import 'dart:developer';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'screens/home_screen.dart';
// import 'screens/Notification_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   _firebaseMessaging.getToken().then((token){
//     log('token: $token');
//   });
//   // await FirebaseMe
//
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
//       // home: const NotificationScreen(),
//     );
//   }
// }
//
