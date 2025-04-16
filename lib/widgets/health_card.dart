// import 'package:flutter/material.dart';
//
// class HealthCard extends StatelessWidget {
//   final String title;
//   final String value;
//   // final IconData icon;
//
//   const HealthCard({
//     super.key,
//     required this.title,
//     required this.value,
//     // required this.icon,
//   });
//
//   @override
// Widget build(BuildContext context) {
//     return Card(
//       color: Colors.blue.shade100,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         // leading: Icon( color: Colors.blue),
//         title: Text(title, style: const TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
//         trailing: Text(value,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//       ),
//     );
// }
//
// }


import 'package:flutter/material.dart';
import '../screens/activity_screen.dart'; // Đảm bảo đúng đường dẫn đến ActivityScreen

class HealthCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap; // Thêm tham số onTap

  const HealthCard({
    super.key,
    required this.title,
    required this.value,
    this.onTap, // Nhận giá trị onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Sử dụng onTap truyền vào
      child: Card(
        color: Colors.blue.shade100,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
          trailing: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
