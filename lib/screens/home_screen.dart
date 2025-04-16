import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/health_card.dart';
import '../models/article.dart';
import '../models/DayActive.dart';
import '../widgets/bottom_nav_bar.dart';
import 'fitness_screen.dart';
import 'ProfileScreen.dart';
import 'together_screen.dart';
import 'Notification_screen.dart';
import 'activity_screen.dart';
import 'article_detail_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    // TogetherPage(),
    FitnessScreen(),
    ProfileScreen(),
    NotificationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Article> _articles = [];
  bool _isLoading = true;
  int visibleCount = 5;

  @override
  void initState() {
    super.initState();
    fetchArticles();
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

  //Hàm tạo biểu đồ từ danh sách DayActive
  List<PieChartSectionData> createChartSections(List<DayActive> activities) {
    // Bước 1: Nhóm theo activityType và đếm số lượng
    Map<String, int> activityCounts = {};

    for (var activity in activities) {
      activityCounts[activity.activityType] =
          (activityCounts[activity.activityType] ?? 0) + 1;
    }

    // Bước 2: Tổng số hoạt động
    int total = activityCounts.values.fold(0, (a, b) => a + b);

    // Bước 3: Định nghĩa màu cho từng loại
    Map<String, Color> colorMap = {
      "Chạy bộ": Colors.blue,
      "Đạp xe": Colors.red,
      "Đi bộ": Colors.green,
      "Ngồi thiền": Colors.orange,
    };

    // Bước 4: Chuyển sang PieChartSectionData
    List<PieChartSectionData> sections = [];

    activityCounts.forEach((type, count) {
      double percent = (count / total) * 100;
      sections.add(PieChartSectionData(
        color: colorMap[type] ?? Colors.grey,
        value: percent,
        title: "${percent.toStringAsFixed(0)}%",
        radius: 60,
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ));
    });

    return sections;
  }

  //lấy dữ liệu từ Firebase
  // Future<List<DayActive>> fetchActivitiesFromFirebase() async {
  //   final snapshot = await FirebaseFirestore.instance.collection('day_activities').get();
  //   return snapshot.docs.map((doc) => DayActive.fromMap(doc.data(), doc.id)).toList();
  // }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Các thẻ sức khỏe
           HealthCard(title: "🏃 Di chuyển", value: "40264 m", onTap: () => _navigateToActivityScreen(context)),
           HealthCard(title: "⏱ Thời gian", value: "3 giờ",onTap: () => _navigateToActivityScreen(context),),
           HealthCard(title: "🔥 Kcal đốt cháy", value: "250 kcal",onTap: () => _navigateToActivityScreen(context),),

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
                      _buildLegend("🛌 Nằm", Colors.orange),
                      _buildLegend("🐥 Đứng", Colors.orange),
                      _buildLegend("🧘 Leo cầu thang", Colors.orange),
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
                  fontStyle: FontStyle.italic, // Chữ in nghiêng
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
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: _chartSections(),
        centerSpaceRadius: 50,
        sectionsSpace: 2,
      ),
    );
  }

  List<PieChartSectionData> _chartSections() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 40,
        title: '40%',
        radius: 60,
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: 30,
        title: '30%',
        radius: 60,
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 20,
        title: '20%',
        radius: 60,
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 10,
        title: '10%',
        radius: 60,
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ];
  }
}