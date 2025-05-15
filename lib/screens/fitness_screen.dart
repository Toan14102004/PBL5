import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/fitness_chart.dart';
import 'id_yte_screen.dart';

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({super.key});

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  List<Map<String, dynamic>> caloriesData = [];
  List<Map<String, dynamic>> movementData = [];
  bool loading = true;

  final String userId = 'user_1029357990';

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    final now = DateTime.now();
    final database = FirebaseDatabase.instance.ref();

    List<Map<String, dynamic>> tempCalories = [];
    List<Map<String, dynamic>> tempMovement = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final day = date.day.toString().padLeft(2, '0');    // vd: "15"
      final month = date.month.toString().padLeft(2, '0'); // vd: "05"
      final year = date.year.toString();                   // vd: "2025"
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      // Lấy calories theo cấu trúc ngày/tháng/năm
      final caloriesSnap = await database.child('daily_calories/$userId/$day/$month/$year').get();
      int kcal = 0;
      // int? kcal;

      if (caloriesSnap.exists) {
        final data = caloriesSnap.value as Map<dynamic, dynamic>;
        // Dữ liệu calories có thể là số thực, mình làm tròn về int
        final calValue = data['calories'];
        if (calValue != null) {
          kcal = (calValue is num) ? calValue.round() : int.tryParse(calValue.toString()) ?? 0;
        }
        print('Calories on $dateStr: $kcal');
      } else {
        print('No calories data on $dateStr');
      }
      tempCalories.add({'date': dateStr, 'kcal': kcal});

      // Lấy thời gian di chuyển theo cấu trúc ngày/tháng/năm
      final moveSnap = await database.child('daily_movement/$userId/$day/$month/$year').get();
      int seconds = 0;
      if (moveSnap.exists) {
        final data = moveSnap.value as Map<dynamic, dynamic>;
        final moveValue = data['total_moving_time_seconds'];
        if (moveValue != null) {
          seconds = (moveValue is num) ? moveValue.round() : int.tryParse(moveValue.toString()) ?? 0;
        }
        print('Movement seconds on $dateStr: $seconds');
      } else {
        print('No movement data on $dateStr');
      }
      tempMovement.add({'date': dateStr, 'seconds': seconds});
    }

    setState(() {
      caloriesData = tempCalories;
      movementData = tempMovement;
      loading = false;
    });
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

  // Biểu đồ thời gian di chuyển với data movementData
  Widget _buildTimeChart() {
    final List<DateTime> last7Days = List.generate(
      7,
          (i) => DateTime.now().subtract(Duration(days: 6 - i)),
    );

    double maxY = 20;
    if (movementData.isNotEmpty) {
      double maxValue = movementData
          .map((e) => (e['seconds'] as int) / 60.0)
          .reduce((a, b) => a > b ? a : b);
      maxY = maxValue + 10;
    }

    final List<BarChartGroupData> barGroups = List.generate(7, (index) {
      double y = 0;
      if (index < movementData.length) {
        y = (movementData[index]['seconds'] as int) / 60.0;
        if (y > maxY) y = maxY;
      }
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: y,
            color: Colors.green,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxY,
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
      );
    });

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: barGroups,
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value < 0 || value >= 7) return const SizedBox();
                  final label = DateFormat('dd/MM').format(last7Days[value.toInt()]);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(label, style: const TextStyle(fontSize: 12)),
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
        ),
      ),
    );
  }



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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("𝔽𝕚𝕥𝕟𝕖𝕤𝕤 𝕋𝕣𝕒𝕔𝕜𝕖𝕣"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OperatingEnergy("🔥 𝓝𝓪̆𝓷𝓰 𝓵𝓾̛𝓸̛̣𝓷𝓰 𝓱𝓸𝓪̣𝓽 𝓭𝓸̣̂𝓷𝓰",
                  _calculateAverageCalories(caloriesData).toString()),
              const SizedBox(height: 30),
              const Text(
                "Biểu đồ hoạt động tuần qua",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              FitnessChart(last7Days: caloriesData),

              const SizedBox(height: 35),
              _AverageTimeOfExercise("⏰  𝓢𝓸̂́ 𝓹𝓱𝓾́𝓽 𝓽𝓱𝓮̂̉ 𝓭𝓾̣𝓬",
                  (_calculateAverageMovement(movementData) ~/ 60).toString()),
              const SizedBox(height: 30),
              const Text(
                "Biểu đồ thời gian hoạt động tuần qua",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTimeChart(),

              const SizedBox(height: 40),
              _buildUpdateHealthIdCard(context),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateAverageCalories(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0;
    final total = data.fold(0, (sum, item) => sum + (item['kcal'] as int));
    return (total / data.length).round();
  }

  int _calculateAverageMovement(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0;
    final total = data.fold(0, (sum, item) => sum + (item['seconds'] as int));
    return (total / data.length).round();
  }

}
