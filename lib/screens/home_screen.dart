import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../services/calorie_calculator.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/health_card.dart';
import '../models/article.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/pie_chart_screen.dart';
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
  int _totalMovingTime = 0; // đơn vị: giây


  @override
  void initState() {
    super.initState();
    fetchArticles();
    fetchAndCalculateCalories();
    fetchAndCalculateMovingTime();

  }
  Future<void> fetchAndCalculateCalories() async {
    final calculator = CalorieCalculator(userId: widget.userId);
    calculator.listenToRealtime((RealtimeResult result) {
      setState(() {
        _totalCalories = result.calories;
      });
      print('🔥 Kcal: ${result.calories.toStringAsFixed(2)}');
    });
  }

  Future<void> fetchAndCalculateMovingTime() async {
    final calculator = CalorieCalculator(userId: widget.userId);
    calculator.listenToRealtime((RealtimeResult result) {
      setState(() {
        _totalMovingTime = result.movingTimeSeconds;
      });
      print('⏱️ Di chuyển: ${result.movingTimeSeconds} giây');
    });
  }

  String formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
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
            HealthCard(title: "🏃 Di chuyển", value: "0 m", onTap: () => _navigateToActivityScreen(context)),
            HealthCard(
              title: "⏱ Thời gian",
              value: formatDuration(_totalMovingTime),
              onTap: () => _navigateToActivityScreen(context),
            ),
            HealthCard(
                title: "🔥 Kcal đốt cháy",
                value: "${_totalCalories.toStringAsFixed(2)} kcal",
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
                  child:PieChartScreen(userId: widget.userId),
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
                      _buildLegend("🚴 Đạp xe", Colors.yellow),
                      _buildLegend("🚶 Đi bộ", Colors.green),
                      _buildLegend("🧘 Ngồi", Colors.orange),
                      _buildLegend("🛌 Nằm", Colors.pink),
                      _buildLegend("🐥 Đứng", Colors.purple),
                      _buildLegend("🧘 Leo cầu thang", Colors.brown),
                      _buildLegend("⚠️ Ngã", Colors.red),
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
      MaterialPageRoute(builder: (context) =>  ActivityScreen(userId: widget.userId)),
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
