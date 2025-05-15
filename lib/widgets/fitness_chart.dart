import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class FitnessChart extends StatelessWidget {
  final List<Map<String, dynamic>> last7Days;

  const FitnessChart({Key? key, required this.last7Days}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          barGroups: List.generate(last7Days.length, (index) {
            final kcal = last7Days[index]['kcal'].toDouble();
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(toY: kcal, width: 16, color: Colors.orange),
              ],
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text('0 kcal',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${value.toInt()}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= last7Days.length) return const SizedBox();
                  String date = last7Days[index]['date'];
                  final parsed = DateTime.parse(date);
                  final formatted = DateFormat('dd/MM').format(parsed);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      formatted,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: true),
        ),
      ),
    );
  }
}
