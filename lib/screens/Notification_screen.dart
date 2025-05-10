import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/notification_service.dart';
import '../models/activity_notification.dart'; // import model ActivityNotification

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  List<ActivityNotification> _notifications = []; // Đổi kiểu dữ liệu thành ActivityNotification
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      // Tạm dùng user ID cố định để test
      const userId = 'user_1029357990';
      final data = await _notificationService.fetchNotificationsFromActivities(userId);

      setState(() {
        _notifications = data; // Sử dụng ActivityNotification thay vì Map
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
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : _notifications.isEmpty
          ? const Center(child: Text('Không có thông báo nào.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationCard(notification.title, notification.content); // Sử dụng ActivityNotification
        },
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
