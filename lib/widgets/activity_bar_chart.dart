// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class ActivityBarChart extends StatelessWidget {
//   final Color color;
//
//   const ActivityBarChart({super.key, required this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         backgroundColor: Colors.transparent,
//         barGroups: List.generate(12, (index) {
//           return BarChartGroupData(
//             x: index,
//             barRods: [
//               BarChartRodData(
//                 toY: (index % 4 == 0) ? 6 : (index % 3 == 0) ? 4 : 2,
//                 width: 5,
//                 color: color,
//               )
//             ],
//           );
//         }),
//         gridData: FlGridData(show: false),
//         borderData: FlBorderData(show: false),
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         ),
//       ),
//     );
//   }
// }