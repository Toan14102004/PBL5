import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fl_chart/fl_chart.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi_VN', null).then((_) {
      final now = DateTime.now();
      setState(() {
        formattedDate = DateFormat("EEEE, dd MMMM, yyyy", "vi_VN").format(now);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // <-- Đổi màu icon back thành trắng
        title: Text(
          formattedDate.isNotEmpty ? "Hôm nay, $formattedDate" : "Đang tải...",
          style: const TextStyle(color: Colors.white, fontSize: 18),
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
        child: ListView(
          children: [
            _buildOverviewCard(),
            const SizedBox(height: 20),
            _buildActivityPieChart(),
            const SizedBox(height: 20),
            const Text("Hoạt động hôm nay",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            _buildActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Colors.deepPurple, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _StatItem(
                label: "KCAL",
                value: "357",
                color: Colors.orange,
                icon: Icons.local_fire_department,
              ),
              _StatItem(
                label: "Phút",
                value: "47",
                color: Colors.greenAccent,
                icon: Icons.timer,
              ),
              _StatItem(
                label: "Té",
                value: "1",
                color: Colors.redAccent,
                icon: Icons.warning_amber_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildActivityPieChart() {
    return Card(
      elevation: 4,
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Tỉ lệ hoạt động",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: _generateSections(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 35,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    return [
      PieChartSectionData(value: 40, title: '', color: Colors.blueAccent, radius: 50),
      PieChartSectionData(value: 30, title: '', color: Colors.greenAccent, radius: 50),
      PieChartSectionData(value: 10, title: '', color: Colors.amber, radius: 50),
      PieChartSectionData(value: 5, title: '', color: Colors.redAccent, radius: 50),
      PieChartSectionData(value: 15, title: '', color: Colors.purpleAccent, radius: 50),
    ];
  }

  Widget _buildLegend() {
    final items = [
      {"label": "Đi", "color": Colors.blueAccent},
      {"label": "Ngồi", "color": Colors.greenAccent},
      {"label": "Đứng", "color": Colors.amber},
      {"label": "Té", "color": Colors.redAccent},
      {"label": "Khác", "color": Colors.purpleAccent},
    ];
    return Wrap(
      spacing: 20,
      children: items
          .map(
            (item) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 10, color: item["color"] as Color),
            const SizedBox(width: 6),
            Text(item["label"] as String, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      )
          .toList(),
    );
  }

  Widget _buildActivityList() {
    final mockActivities = [
      {"time": "07:00 - 07:30", "type": "Đi bộ", "color": Colors.blueAccent},
      {"time": "08:00 - 08:45", "type": "Ngồi", "color": Colors.greenAccent},
      {"time": "09:00 - 09:05", "type": "Té ngã", "color": Colors.redAccent},
      {"time": "10:00 - 10:10", "type": "Đứng", "color": Colors.amber},
    ];

    return Column(
      children: mockActivities.map((activity) {
        return Card(
          color: Colors.grey.shade800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            leading: Icon(Icons.access_time, color: activity["color"] as Color),
            title: Text(activity["type"] as String,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            subtitle: Text(activity["time"] as String, style: const TextStyle(color: Colors.grey)),
          ),
        );
      }).toList(),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 6),
        Text(value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label.toUpperCase(),
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

