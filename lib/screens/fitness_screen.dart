import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'id_yte_screen.dart';
class FitnessScreen extends StatelessWidget {
   FitnessScreen({super.key});

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
            // Text(
            //   "Hôm nay",
            //   style: TextStyle(fontSize: 16, color: Colors.grey),
            // ),
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
              // _buildStatCard("⏱ Thời gian chạy", "35 phút"),
              // _buildStatCard("🔥 Kcal đốt cháy", "250 kcal"),
              // _buildStatCard("💓 Nhịp tim", "120 bpm"),

              _OperatingEnergy("🔥 Năng lượng hoạt động ", "409 kcal"),
              const SizedBox(height: 20),
              const Text(
                "Biểu đồ hoạt động tuần qua",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildActivityChart(),
              const SizedBox(height: 20),
              _AverageTimeOfExercise("⏰  Số phút thể dục ","54"),
              const Text(
                "Biểu đồ thời gian hoạt động tuần qua",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTimeChart(),
              const SizedBox(height: 20),
              _buildUpdateHealthIdCard(context), // truyền context ở đây
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


  Widget _OperatingEnergy(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: TextEditingController(
              text:
              'Trong 7 ngày qua bạn đã đốt cháy trung bình $value kilocalo một ngày.',
            ),
            readOnly: true,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
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

  Widget _AverageTimeOfExercise(String title, String value){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: TextEditingController(
              text:
              'Bạn đã nhận được trung bình $value phút thể dục 1 ngày trong 7 ngày qua.',
            ),
            readOnly: true,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }


   final List<FlSpot> weeklyData = [
     FlSpot(0, 30),
     FlSpot(1, 45),
     FlSpot(2, 20),
     FlSpot(3, 60),
     FlSpot(4, 50),
     FlSpot(5, 40),
     FlSpot(6, 35),
   ];
   /// Biểu đồ thời gian hoạt động trong tuần (giờ)
   Widget _buildTimeChart() {
     return SizedBox(
       height: 250, // bạn có thể điều chỉnh chiều cao theo mong muốn
       child: LineChart(
         LineChartData(
           minX: 0,
           maxX: 6,
           minY: 0,
           maxY: 70,
           gridData: FlGridData(show: true),
           titlesData: FlTitlesData(
             bottomTitles: AxisTitles(
               sideTitles: SideTitles(
                 showTitles: true,
                 getTitlesWidget: (value, meta) {
                   const days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
                   if (value.toInt() < 0 || value.toInt() >= days.length) return const SizedBox();
                   // Chỉ hiển thị nếu là số nguyên
                   if (value % 1 != 0) return const SizedBox();
                   return Padding(
                     padding: const EdgeInsets.only(top: 8.0),
                     child: Text(
                       days[value.toInt()],
                       style: TextStyle(fontSize: 12),
                     ),
                   );
                 },
               ),
             ),
             leftTitles: AxisTitles(
               sideTitles: SideTitles(
                 showTitles: true,
                 reservedSize: 35,
                 getTitlesWidget: (value, meta) => Text('${value.toInt()}p'),
               ),
             ),
             topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
             rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
           ),
           lineBarsData: [
             LineChartBarData(
               spots: weeklyData,
               isCurved: true,
               color: Colors.green,
               barWidth: 3,
               dotData: FlDotData(show: true),
               belowBarData: BarAreaData(show: false),
             )
           ],
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


  /// Widget cho title "C  nh t ID y t  của b n " v i text "Trong tr ng h p kh n c p , i u quan tr ng l  nh ng ng i ph n h i u tin c  nh t " v  th m 1 button b t u m i
   Widget _buildUpdateHealthIdCard(BuildContext context) {
     return Card(
       color: Colors.blue.shade100,
       margin: const EdgeInsets.symmetric(vertical: 8),
       child: ListTile(
         title: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             const Icon(Icons.health_and_safety, color: Colors.blue, size: 40),
             const SizedBox(height: 8),
             const Text(
               "Cập nhật ID y tế của bạn",
               style: TextStyle(fontWeight: FontWeight.bold),
             ),
           ],
         ),
         subtitle: const Text(
           "Trong trường hợp khẩn cấp, điều quan trọng là những người phản hồi đầu tiên có thông tin cập nhật",
         ),
         trailing: ElevatedButton(
           onPressed: () {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const IdYteScreen()),
             );
           },
           style: ElevatedButton.styleFrom(
             backgroundColor: Colors.blue,
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
           ),
           child: const Text('Bắt đầu'),
         ),
       ),
     );
   }




}
