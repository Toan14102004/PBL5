import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';


import 'id_yte_screen.dart';
class FitnessScreen extends StatelessWidget {
   FitnessScreen({super.key});

   List<DateTime> getLast7Days() {
     final now = DateTime.now();
     return List.generate(7, (index) {
       final day = now.subtract(Duration(days: 6 - index));
       return DateTime(day.year, day.month, day.day); // Chỉ lấy ngày, bỏ giờ
     });
   }

   List<Map<String, dynamic>> last7Days = [
     {'date': '2025-04-10', 'kcal': 320},
     {'date': '2025-04-11', 'kcal': 450},
     {'date': '2025-04-12', 'kcal': 500},
     {'date': '2025-04-13', 'kcal': 400},
     {'date': '2025-04-14', 'kcal': 600},
     {'date': '2025-04-15', 'kcal': 700},
     {'date': '2025-04-16', 'kcal': 550},
   ];

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text(
              "𝔽𝕚𝕥𝕟𝕖𝕤𝕤 𝕋𝕣𝕒𝕔𝕜𝕖𝕣",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 4),
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
              _OperatingEnergy("🔥 𝓝𝓪̆𝓷𝓰 𝓵𝓾̛𝓸̛̣𝓷𝓰 𝓱𝓸𝓪̣𝓽 𝓭𝓸̣̂𝓷𝓰 ", "409 kcal"),
              const SizedBox(height: 30),
              const Text(
                "Biểu đồ hoạt động tuần qua",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              // _buildActivityChart(),
              buildActivityChart(last7Days),
              const SizedBox(height: 35),
              _AverageTimeOfExercise("⏰  𝓢𝓸̂́ 𝓹𝓱𝓾́𝓽 𝓽𝓱𝓮̂̉ 𝓭𝓾̣𝓬 ","54"),
              const SizedBox(height: 30),
              const Text(
                "Biểu đồ thời gian hoạt động tuần qua",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTimeChart(),
              const SizedBox(height: 40),
              _buildUpdateHealthIdCard(context), // truyền context ở đây
            ],
          ),
        ),
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


   final List<FlSpot> weeklyData = [
     FlSpot(0, 30),
     FlSpot(1, 45),
     FlSpot(2, 20),
     FlSpot(3, 60),
     FlSpot(4, 50),
     FlSpot(5, 40),
     FlSpot(6, 35),
   ];
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

   /// Biểu đồ hoạt động trong tuần (kcal tiêu hao)
   Widget buildActivityChart(List<Map<String, dynamic>> last7Days) {
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
                     return Padding(
                       padding: const EdgeInsets.only(right: 8),
                       child: Text('0 kcal',
                           style: const TextStyle(
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

   Widget _buildTimeChart() {
     final List<DateTime> last7Days = List.generate(7, (i) => DateTime.now().subtract(Duration(days: 6 - i)));

     return SizedBox(
       height: 250,
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
                   int index = value.toInt();
                   if (index < 0 || index >= 7 || value % 1 != 0) return const SizedBox();
                   final dayLabel = DateFormat('dd/MM').format(last7Days[index]);
                   return Padding(
                     padding: const EdgeInsets.only(top: 8.0),
                     child: Text(dayLabel, style: const TextStyle(fontSize: 12)),
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
