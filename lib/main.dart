// import 'package:flutter/material.dart';
// import 'screens/home_screen.dart';
// import 'package:intl/date_symbol_data_local.dart';
// // import 'screens/Profile_screen.dart';
//
// void main() {
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
//       // home: HomeScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'screens/home_screen.dart';  // Đảm bảo bạn đã import đúng màn hình HomeScreen.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      // Chuyển về HomeScreen thay vì FirebaseTestScreen
      home: const HomeScreen(),
    );
  }
}


//phiên bản test DB
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
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
//       home: FirebaseTestScreen(),
//     );
//   }
// }
//
// class FirebaseTestScreen extends StatefulWidget {
//   @override
//   _FirebaseTestScreenState createState() => _FirebaseTestScreenState();
// }
//
// class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
//   final FirebaseDatabase _database = FirebaseDatabase.instance;
//
//   Future<Map<String, dynamic>> _fetchData() async {
//     try {
//       // Lấy dữ liệu từ Realtime Database
//       DatabaseReference ref = _database.ref('activity_records/daily_1');
//       DataSnapshot snapshot = await ref.get();
//
//       if (snapshot.exists) {
//         // Chuyển đổi dữ liệu thành Map
//         return Map<String, dynamic>.from(snapshot.value as Map);
//       } else {
//         throw Exception('No data found');
//       }
//     } catch (e) {
//       throw Exception('Error fetching data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Firebase Data Test'),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: _fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No data found'));
//           }
//
//           Map<String, dynamic> data = snapshot.data!;
//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               String key = data.keys.elementAt(index);
//               return ListTile(
//                 title: Text(key),
//                 subtitle: Text(data[key].toString()),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
