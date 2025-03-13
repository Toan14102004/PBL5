import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text(
              "Fitness Tracker",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 4), // K cách giữa 2 dòng
            Text(
              "Hôm nay",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatCard("⏱ Thời gian chạy", "35 phút"),
              _buildStatCard("🔥 Kcal đốt cháy", "250 kcal"),
              _buildStatCard("💓 Nhịp tim", "120 bpm"),

              const SizedBox(height: 20),
              const Text(
                "Biểu đồ hoạt động tuần qua",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildActivityChart(),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget hiển thị các chỉ số chạy bộ
  Widget _buildStatCard(String title, String value) {
    return Card(
      color: Colors.blue.shade100,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }


  /// Biểu đồ hoạt động trong tuần (kcal tiêu hao)
  Widget _buildActivityChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: [
            _buildBarData(0, 300), // Thứ 2: 300 kcal
            _buildBarData(1, 450), // Thứ 3: 450 kcal
            _buildBarData(2, 500), // Thứ 4: 500 kcal
            _buildBarData(3, 400), // Thứ 5: 400 kcal
            _buildBarData(4, 600), // Thứ 6: 600 kcal
            _buildBarData(5, 700), // Thứ 7: 700 kcal
            _buildBarData(6, 550), // Chủ Nhật: 550 kcal
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40, // Để chữ kcal không bị cắt
                getTitlesWidget: (value, meta) {
                  if (value == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '0 kcal', // Ghi đơn vị kcal 1 lần ở vị trí 0
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${value.toInt()}', // Chỉ hiển thị số, không có kcal
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
                  const days = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(days[value.toInt()],
                        style: const TextStyle(fontSize: 12)),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles( // Ẩn số liệu phía trên
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles( // Ẩn số liệu phía phải
              sideTitles: SideTitles(showTitles: false),
            ),
          ),

          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: true),
        ),
      ),
    );
  }

  /// Hàm tạo dữ liệu cho biểu đồ cột
  BarChartGroupData _buildBarData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.orangeAccent, // Màu cam cho kcal
          width: 16,
        )
      ],
    );
  }

}