import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/calorie_calculator.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/health_card.dart';
import '../models/article.dart';
import '../models/Record.dart';
import '../widgets/bottom_nav_bar.dart';
import 'fitness_screen.dart';
import 'ProfileScreen.dart';
import 'Notification_screen.dart';
import 'activity_screen.dart';
import 'article_detail_screen.dart';
import 'running_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);
  // const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeContent(userId: widget.userId),
      FitnessScreen(),
      ProfileScreen(userId: widget.userId),
      NotificationScreen(),
    ];
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: const CustomAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final String userId;

  const HomeContent({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Article> _articles = [];
  bool _isLoading = true;
  int visibleCount = 5;
  double _totalCalories = 0.0;

  @override
  void initState() {
    super.initState();
    fetchArticles();
    printAllCaloriesData();
    fetchAndCalculateCalories();
  }

  Future<void> printAllCaloriesData() async {
    final dbRef = FirebaseDatabase.instance.ref("daily_calories");
    final snapshot = await dbRef.get();

    if (!snapshot.exists) {
      print('⚠️ Không có dữ liệu trong nút daily_calories.');
      return;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    print('📋 Dữ liệu trong daily_calories:');
    for (final userEntry in data.entries) {
      final userId = userEntry.key;
      final dailyRecords = Map<String, dynamic>.from(userEntry.value);

      for (final dayEntry in dailyRecords.entries) {
        final date = dayEntry.key;
        final record = Map<String, dynamic>.from(dayEntry.value);

        final calories = record['calories'];
        print('🧾 User: $userId | Date: $date | Calories: $calories');
      }
    }
  }

  Future<void> fetchAndCalculateCalories() async {
    final calculator = CalorieCalculator(userId: widget.userId);
    final totalCalories = await calculator.fetchAndCalculateAndUpload(); // trả về giá trị kcal tổng
    print('đang test');
    setState(() {
      _totalCalories = totalCalories;
    });
  }


  Future<void> fetchArticles() async {
    final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=439e9cb051f84ad68e694370e90eeeb3',
    ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> articlesJson = jsonData['articles'];

      setState(() {
        _articles = articlesJson
            .map((jsonItem) => Article.fromJson(jsonItem))
            .where((a) => a.imageUrl.isNotEmpty)
            .toList();
        _isLoading = false;
      });
    } else {
      print("Lỗi khi gọi API: ${response.statusCode}");
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           HealthCard(title: "🏃 Di chuyển", value: "40264 m", onTap: () => _navigateToActivityScreen(context)),
           HealthCard(title: "⏱ Thời gian", value: "3 giờ",onTap: () => _navigateToActivityScreen(context),),
           // HealthCard(title: "🔥 Kcal đốt cháy", value: "250 kcal",onTap: () => _navigateToActivityScreen(context),),
            HealthCard(
              title: "🔥 Kcal đốt cháy",
              value: "${_totalCalories.toStringAsFixed(0)} kcal",
              onTap: () => _navigateToActivityScreen(context),
            ),
          Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RunningScreen()),
                    );
                  },
                  icon: Icon(Icons.directions_run),
                  label: Text("Bắt đầu chạy bộ"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

          // Biểu đồ hình tròn
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Hoạt động hôm nay",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 350,
                  child: PieChartWidget(),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegend("🏃 Chạy bộ", Colors.blue),
                      _buildLegend("🚴 Đạp xe", Colors.red),
                      _buildLegend("🚶 Đi bộ", Colors.green),
                      _buildLegend("🧘 Ngồi", Colors.orange),
                      _buildLegend("🛌 Nằm", Colors.pink),
                      _buildLegend("🐥 Đứng", Colors.purple),
                      _buildLegend("🧘 Leo cầu thang", Colors.brown),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Biểu đồ tỉ lệ hoạt động trong ngày",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Bài báo mới về sức khỏe",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: visibleCount < _articles.length ? visibleCount : _articles.length,
            itemBuilder: (context, index) {
              return _buildArticleItem(_articles[index]);
            },
          ),

          if (visibleCount < _articles.length)
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    visibleCount += 5;
                  });
                },
                child: Text('Thêm', style: TextStyle(fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(width: 20, height: 20, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  void _navigateToActivityScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ActivityScreen()),
    );
  }

  Widget _buildArticleItem(Article article) {
    return Card(
      color: Color(0xFFFFF0F5),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            article.imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
          ),
        ),
        title: Text(article.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(article.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(url: article.url),
            ),
          );
        },
      ),
    );
  }
}

// Biểu đồ hình tròn
class PieChartWidget extends StatelessWidget {

  List<Record> sampleRecords = [
    Record(
      startTime: "2025-04-13T07:00:00",
      endTime: "2025-04-13T07:00:10",
      dayActiveId: "d1",
      activityType: "Chạy bộ", // 30 phút
    ),
    Record(

      startTime: "2025-04-13T08:00:00",
      endTime: "2025-04-13T08:40:00",
      dayActiveId: "d1",
      activityType: "Đạp xe", // 40 phút
    ),
    Record(

      startTime: "2025-04-13T09:00:00",
      endTime: "2025-04-13T09:20:00",
      dayActiveId: "d1",
      activityType: "Đi bộ", // 20 phút
    ),
    Record(

      startTime: "2025-04-13T10:00:00",
      endTime: "2025-04-13T10:50:00",
      dayActiveId: "d1",
      activityType: "Ngồi", // 50 phút
    ),
    Record(

      startTime: "2025-04-13T11:00:00",
      endTime: "2025-04-13T11:45:00",
      dayActiveId: "d1",
      activityType: "Nằm", // 45 phút
    ),
    Record(

      startTime: "2025-04-13T12:00:00",
      endTime: "2025-04-13T12:10:00",
      dayActiveId: "d1",
      activityType: "Đứng", // 10 phút
    ),
  ];


  List<PieChartSectionData> createChartSectionsFromRecords(List<Record> records) {
    Map<String, Duration> activityDurations = {};

    for (var record in records) {
      DateTime start = DateTime.parse(record.startTime);
      DateTime end = DateTime.parse(record.endTime);

      if (end.isAfter(start)) {
        Duration duration = end.difference(start);
        activityDurations[record.activityType] =
            (activityDurations[record.activityType] ?? Duration()) + duration;
      }
    }

    Duration totalDuration = activityDurations.values.fold(
      Duration(),
          (sum, dur) => sum + dur,
    );

    if (totalDuration.inSeconds == 0) return [];

    Map<String, Color> colorMap = {
      "Chạy bộ": Colors.blue,
      "Đạp xe": Colors.red,
      "Đi bộ": Colors.green,
      "Ngồi": Colors.orange,
      "Nằm": Colors.pink,
      "Đứng": Colors.purple,
      "Leo cầu thang": Colors.brown,
    };

    List<PieChartSectionData> sections = [];

    activityDurations.forEach((activity, duration) {
      double percent = duration.inSeconds / totalDuration.inSeconds * 100;
      sections.add(PieChartSectionData(
        color: colorMap[activity] ?? Colors.grey,
        value: percent,
        title: "${percent.toStringAsFixed(0)}%",
        radius: 60,
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ));
    });

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = createChartSectionsFromRecords(sampleRecords);

    if (sections.isEmpty) {
      return Center(
        child: Text(
          'Dữ liệu đang được cập nhật\nXin bạn chờ trong giây lát...',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }
}