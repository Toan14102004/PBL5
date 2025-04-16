import 'package:flutter/material.dart';
import '../widgets/activity_ring.dart';
import '../widgets/activity_bar_chart.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade300, // xám ghi
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white, // màu thanh AppBar
        title: const Text(
          "Hôm nay, ngày 19 thg 3, 2025",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.greenAccent),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.greenAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thanh điều hướng tuần
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                return CircleAvatar(
                  backgroundColor: index == 2 ? Colors.pink : Colors.black,
                  child: Text(
                    'T${index + 2}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Vòng tròn hoạt động
            const SizedBox(height: 200, child: ActivityRing()),

            const SizedBox(height: 30),

            // Biểu đồ di chuyển
            const Text("Di chuyển", style: TextStyle(color: Colors.white, fontSize: 18)),
            const Text("357/300 KCAL",
                style: TextStyle(color: Colors.redAccent, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const SizedBox(height: 80, child: ActivityBarChart(color: Colors.redAccent)),

            // Biểu đồ thể dục
            const Text("Thể dục", style: TextStyle(color: Colors.white, fontSize: 18)),
            const Text("47/30 PHÚT",
                style: TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const SizedBox(height: 80, child: ActivityBarChart(color: Colors.greenAccent)),
          ],
        ),
      ),
    );
  }
}
