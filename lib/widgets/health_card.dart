import 'package:flutter/material.dart';

class HealthCard extends StatelessWidget {
  final String title;
  final String value;
  // final IconData icon;

  const HealthCard({
    super.key,
    required this.title,
    required this.value,
    // required this.icon,
  });

  @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     color: Color(0xFFBBDEFB),
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: ListTile(
  //       leading: Icon(icon, color: Colors.blue, size: 32),
  //       title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
  //       subtitle: Text(value, style: const TextStyle(fontSize: 16)),
  //     ),
  //   );
  // }

  @override
Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade100,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // leading: Icon( color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
        trailing: Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
}

}
