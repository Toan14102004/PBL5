// import 'package:flutter/material.dart';
// import 'package:health_app_ui/screens/together_screen.dart';
// import '../widgets/custom_app_bar.dart';
// import '../widgets/health_card.dart';
// import '../widgets/bottom_nav_bar.dart';
// // import 'profile_screen.dart';
// import 'fitness_screen.dart';
// import 'ProfileScreen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   // HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = [
//     // const HomeContent(),
//     HomeContent(),
//     TogetherPage(),
//     const FitnessScreen(),
//     // const ProfileScreen(), // Thêm trang ProfileScreen vào danh sách
//     ProfileScreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F5F5),
//       appBar: const CustomAppBar(),
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
//
// class HomeContent extends StatelessWidget {
//   // const HomeContent({super.key});
//   HomeContent({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Các thẻ sức khỏe
//           const HealthCard(title: "🏃 Di chuyển", value: "40264 m"),
//           const HealthCard(title: "⏱ Thời gian", value: "3 giờ"),
//           const HealthCard(title: "🔥 Kcal đốt cháy", value: "250 kcal"),
//
// //               _buildStatCard("🔥 Kcal đốt cháy", "250 kcal"),
// //               _buildStatCard("💓 Nhịp tim", "120 bpm"),
//
//           // Tiêu đề danh sách bài báo
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               "Bài báo mới về sức khỏe",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//           ),
//
//           // Danh sách bài báo
//           ListView.builder(
//             shrinkWrap: true, // Cho phép ListView nằm trong SingleChildScrollView
//             physics: NeverScrollableScrollPhysics(), // Tắt cuộn riêng để tránh lỗi
//             itemCount: articles.length,
//             itemBuilder: (context, index) {
//               return _buildArticleItem(articles[index]);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Danh sách bài báo
//   final List<Map<String, String>> articles = [
//     {
//       "title": "Cách theo dõi huyết áp chính xác",
//       "subtitle": "Tìm hiểu cách đo huyết áp đúng cách và phân tích kết quả.",
//       "image": "https://omron-yte.com.vn/wp-content/uploads/2021/07/cach-quan-vong-bit.jpg"
//     },
//     {
//       "title": "Theo dõi giấc ngủ: Lợi ích và cách làm",
//       "subtitle": "Giấc ngủ ảnh hưởng thế nào đến sức khỏe? Cách cải thiện chất lượng giấc ngủ.",
//       "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFC9KoZmZ9q-AHFyE3KTOP0cSgt8I36nUHKw&sp"
//     },
//     {
//       "title": "Đếm bước chân và lợi ích sức khỏe",
//       "subtitle": "Việc đi bộ hàng ngày ảnh hưởng thế nào đến sức khỏe tim mạch?",
//       "image": "https://static.tnex.com.vn/uploads/2022/11/word-image-10228-1.jpeg"
//     },
//     {
//       "title": "Theo dõi lượng nước uống mỗi ngày",
//       "subtitle": "Cách duy trì thói quen uống đủ nước để tăng cường sức khỏe.",
//       "image": "https://cdn.unityfitness.vn/2024/12/luong-nuoc-uong-moi-ngay-theo-can-nang-2.jpg"
//     },
//   ];
//
//   // Widget hiển thị mỗi bài báo
//   Widget _buildArticleItem(Map<String, String> article) {
//     return Card(
//       color: Color(0xFFFFF0F5),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(10),
//         leading: ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: Image.network(article["image"]!, width: 80, height: 80, fit: BoxFit.cover),
//         ),
//         title: Text(article["title"]!, style: TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(article["subtitle"]!),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/health_card.dart';
import '../widgets/bottom_nav_bar.dart';
import 'fitness_screen.dart';
import 'ProfileScreen.dart';
import 'together_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    TogetherPage(),
    const FitnessScreen(),
    ProfileScreen(),
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

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Các thẻ sức khỏe
          const HealthCard(title: "🏃 Di chuyển", value: "40264 m"),
          const HealthCard(title: "⏱ Thời gian", value: "3 giờ"),
          const HealthCard(title: "🔥 Kcal đốt cháy", value: "250 kcal"),

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
                      _buildLegend("🧘 Ngồi thiền", Colors.orange),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical:5, horizontal: 10),
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: Text(
          //       "Biểu đồ tỉ lệ hoạt động trong ngày",
          //       style: TextStyle(
          //         fontSize: 16,
          //         color: Colors.grey,
          //         fontStyle: FontStyle.italic, // Chữ in nghiêng
          //       ),
          //     ),
          //   ),
          // ),
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

    //Tiêu đề danh sách bài báo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Bài báo mới về sức khỏe",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // Danh sách bài báo
          ListView.builder(
            shrinkWrap: true, // Cho phép ListView nằm trong SingleChildScrollView
            physics: NeverScrollableScrollPhysics(), // Tắt cuộn riêng để tránh lỗi
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return _buildArticleItem(articles[index]);
            },
          ),
        ],
      ),
    );
  }

  //Danh sách bài báo
  final List<Map<String, String>> articles = [
    {
      "title": "Cách theo dõi huyết áp chính xác",
      "subtitle": "Tìm hiểu cách đo huyết áp đúng cách và phân tích kết quả.",
      "image": "https://omron-yte.com.vn/wp-content/uploads/2021/07/cach-quan-vong-bit.jpg"
    },
    {
      "title": "Theo dõi giấc ngủ: Lợi ích và cách làm",
      "subtitle": "Giấc ngủ ảnh hưởng thế nào đến sức khỏe? Cách cải thiện chất lượng giấc ngủ.",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFC9KoZmZ9q-AHFyE3KTOP0cSgt8I36nUHKw&sp"
    },
    {
      "title": "Đếm bước chân và lợi ích sức khỏe",
      "subtitle": "Việc đi bộ hàng ngày ảnh hưởng thế nào đến sức khỏe tim mạch?",
      "image": "https://static.tnex.com.vn/uploads/2022/11/word-image-10228-1.jpeg"
    },
    {
      "title": "Theo dõi lượng nước uống mỗi ngày",
      "subtitle": "Cách duy trì thói quen uống đủ nước để tăng cường sức khỏe.",
      "image": "https://cdn.unityfitness.vn/2024/12/luong-nuoc-uong-moi-ngay-theo-can-nang-2.jpg"
    },
  ];

  // Widget hiển thị mỗi bài báo
  Widget _buildArticleItem(Map<String, String> article) {
    return Card(
      color: Color(0xFFFFF0F5),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(article["image"]!, width: 80, height: 80, fit: BoxFit.cover),
        ),
        title: Text(article["title"]!, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(article["subtitle"]!),
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