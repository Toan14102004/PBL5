import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text("Thông báo", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),
            _buildSectionTitle("Mới"),
            _buildNotificationCard("🚨 Cảnh báo té ngã!", "Chúng tôi đã phát hiện một cú ngã. Vui lòng kiểm tra ngay!"),
            _buildNotificationCard("🏃‍♂️ Chúc mừng!", "Bạn vừa hoàn thành một quãng đường chạy mới."),

            const SizedBox(height: 12),
            _buildSectionTitle("Hôm nay"),
            _buildNotificationCard("⏳ Bạn đã ngồi liên tục 2 giờ.", "Hãy đứng lên vận động một chút nào!"),
            _buildNotificationCard("✨ Bạn đã chạy tổng cộng 5km hôm nay!", "Cố gắng duy trì phong độ nhé!"),

            const SizedBox(height: 12),
            _buildSectionTitle("Trước đó"),
            _buildNotificationCard("🔴 Bạn có một cú ngã vào hôm qua.", "Hãy kiểm tra lại tình trạng sức khỏe của bạn."),
            _buildNotificationCard("🏆 Thành tích tuần trước: 20km!", "Hãy xem liệu bạn có thể phá kỷ lục đó không!"),
            _buildNotificationCard("📉 Hoạt động của bạn đang giảm.", "Hãy cố gắng đi bộ hoặc chạy bộ nhiều hơn!"),
          ],
        ),
      ),
      // bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildNotificationCard(String title, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
