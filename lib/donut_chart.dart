// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
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
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color(0xFFF8F6F6), // Màu nền theo yêu cầu
//       ),
//       home: const ActivityScreen(),
//     );
//   }
// }
//
// class ActivityScreen extends StatelessWidget {
//   const ActivityScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: DonutChart(),
//       ),
//     );
//   }
// }
//
// class DonutChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             'Hoạt động hôm nay',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(
//           height: 250,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               PieChart(
//                 PieChartData(
//                   sectionsSpace: 2,
//                   centerSpaceRadius: 60, // Điều chỉnh khoảng trống giữa vòng tròn
//                   sections: [
//                     PieChartSectionData(
//                       value: 40,
//                       title: '40%',
//                       color: Colors.blue,
//                       radius: 50,
//                     ),
//                     PieChartSectionData(
//                       value: 30,
//                       title: '30%',
//                       color: Colors.red,
//                       radius: 50,
//                     ),
//                     PieChartSectionData(
//                       value: 20,
//                       title: '20%',
//                       color: Colors.green,
//                       radius: 50,
//                     ),
//                     PieChartSectionData(
//                       value: 10,
//                       title: '10%',
//                       color: Colors.orange,
//                       radius: 50,
//                     ),
//                   ],
//                 ),
//               ),
//               const Text(
//                 'Biểu đồ\nhoạt động\ntrong ngày',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//         Column(
//           children: [
//             _buildLegendItem('🏃‍♂️ Chạy bộ', Colors.blue),
//             _buildLegendItem('🚴‍♂️ Đạp xe', Colors.red),
//             _buildLegendItem('🚶‍♂️ Đi bộ', Colors.green),
//             _buildLegendItem('🧘‍♂️ Ngồi thiền', Colors.orange),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLegendItem(String text, Color color) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
//       child: Row(
//         children: [
//           Container(
//             width: 16,
//             height: 16,
//             decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//           ),
//           const SizedBox(width: 8),
//           Text(text, style: const TextStyle(fontSize: 16)),
//         ],
//       ),
//     );
//   }
// }


import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyExerciseLineChart extends StatelessWidget {
  final List<int> minutes = [30, 45, 20, 60, 50, 40, 35]; // Số phút tập mỗi ngày

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 250,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}m',
                      style: const TextStyle(fontSize: 12));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return Text(days[value.toInt()],
                      style: const TextStyle(fontSize: 12));
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                minutes.length,
                    (index) => FlSpot(index.toDouble(), minutes[index].toDouble()),
              ),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
