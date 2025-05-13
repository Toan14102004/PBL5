import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../models/activity_notification.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  List<ActivityNotification> _notifications = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      const userId = 'user_1029357990';
      final data = await _notificationService.fetchNotificationsFromActivities(userId);

      setState(() {
        _notifications = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Lỗi khi tải thông báo: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayList = <ActivityNotification>[];
    final yesterdayList = <ActivityNotification>[];
    final earlierList = <ActivityNotification>[];

    for (var noti in _notifications) {
      final notiDate = DateTime(noti.timestamp.year, noti.timestamp.month, noti.timestamp.day);

      if (notiDate == today) {
        todayList.add(noti);
      } else if (notiDate == yesterday) {
        yesterdayList.add(noti);
      } else {
        earlierList.add(noti);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : _notifications.isEmpty
          ? const Center(child: Text('Không có thông báo nào.'))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.asset(
            'assets/images/notification.gif',
            height: 180,
          ),
          const SizedBox(height: 20),
          if (todayList.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("📅 Mới", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...todayList.map((n) => _buildNotificationCard(n.title, n.content)),
            const SizedBox(height: 16),
          ],
          if (yesterdayList.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("📆 Hôm qua", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...yesterdayList.map((n) => _buildNotificationCard(n.title, n.content)),
            const SizedBox(height: 16),
          ],
          if (earlierList.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("📂 Trước đó", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...earlierList.map((n) => _buildNotificationCard(n.title, n.content)),
          ],
        ],
      ),
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
