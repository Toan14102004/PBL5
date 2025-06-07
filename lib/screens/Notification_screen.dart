import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_app_ui/screens/map_screen.dart';
import '../services/notification_service.dart';
import '../models/activity_notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const userId = 'user_1029357990';

    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: StreamBuilder<List<ActivityNotification>>(
        stream: _notificationService.mergedNotifications(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Mới: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text('Không có thông báo nào.'));
          }

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final yesterday = today.subtract(const Duration(days: 1));

          final todayList = <ActivityNotification>[];
          final yesterdayList = <ActivityNotification>[];
          final earlierList = <ActivityNotification>[];

          for (var noti in notifications) {
            final notiDate = DateTime(
              noti.timestamp.year,
              noti.timestamp.month,
              noti.timestamp.day,
            );
            if (notiDate == today) {
              todayList.add(noti);
            } else if (notiDate == yesterday) {
              yesterdayList.add(noti);
            } else {
              earlierList.add(noti);
            }
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Image.asset('assets/images/notification.gif', height: 180),
              const SizedBox(height: 20),
              if (todayList.isNotEmpty) ...[
                const Text(
                  "Hôm nay",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...todayList.map((n) => _buildNotificationCard(n)),
                const SizedBox(height: 16),
              ],
              if (yesterdayList.isNotEmpty) ...[
                const Text(
                  "Hôm qua",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...yesterdayList.map((n) => _buildNotificationCard(n)),
                const SizedBox(height: 16),
              ],
              if (earlierList.isNotEmpty) ...[
                const Text(
                  "Trước đó",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...earlierList.map((n) => _buildNotificationCard(n)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(ActivityNotification notification) {
    final title = notification.title;
    final content = notification.content;
    LatLng? location = notification.data as LatLng?;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child:
      (location != null)
          ? InkWell(
        onTap: () {
          // Handle tap to open map
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => MapScreen(initialPosition: location),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(content, style: const TextStyle(fontSize: 14)),
          ],
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}