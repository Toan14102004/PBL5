import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../models/activity_notification.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_local.dart';

class NotificationService {
  // static final _notifications = FlutterLocalNotificationsPlugin();

  Stream<List<ActivityNotification>> listenToActivities(String userId) {
    final ref = FirebaseDatabase.instance.ref("activity_records");

    // Trả về một stream để bạn có thể sử dụng StreamBuilder hoặc lắng nghe thủ công
    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      List<ActivityNotification> notifications = [];

      if (!snapshot.exists) return notifications;

      final data = Map<String, dynamic>.from(snapshot.value as Map);

      for (final entry in data.entries) {
        final record = Map<String, dynamic>.from(entry.value);

        if (record['user_id'] != userId) continue;

        final date = record['date'];
        final recordList = List<Map<dynamic, dynamic>>.from(record['records']);

        recordList.sort(
          (a, b) => DateTime.parse(
            a['start_time'],
          ).compareTo(DateTime.parse(b['start_time'])),
        );

        int? currentActivity;
        DateTime? groupStart;
        DateTime? groupEnd;

        void handleGroup() {
          if (currentActivity == null ||
              groupStart == null ||
              groupEnd == null) {
            return;
          }
          final duration = groupEnd!.difference(groupStart!).inMinutes;

          ActivityNotification? notification;

          switch (currentActivity) {
            case 1:
              notification = ActivityNotification(
                title: "🚶 Bạn đã đi bộ",
                content:
                    "Từ ${DateFormat.Hm().format(groupStart!)} đến ${DateFormat.Hm().format(groupEnd!)} vào $date. Tiếp tục vận động nhé!",
                timestamp: groupStart!,
              );
              break;
            case 2:
              if (duration >= 120) {
                notification = ActivityNotification(
                  title: '⏳ Ngồi quá lâu!',
                  content:
                      'Bạn đã ngồi liên tục ${duration ~/ 60} giờ vào $date. Hãy đứng dậy và vận động nhẹ nhé!',
                  timestamp: groupStart!,
                );
              }
              break;
            case 3:
              if (duration >= 30) {
                notification = ActivityNotification(
                  title: "🧍 Bạn đã đứng khá lâu",
                  content:
                      "Bạn đã đứng khoảng $duration phút vào $date. Hãy nghỉ ngơi nếu thấy mỏi nhé!",
                  timestamp: groupStart!,
                );
              }
              break;
            case 4:
              if (duration >= 10 && duration <= 60) {
                notification = ActivityNotification(
                  title: "🛏️ Nghỉ ngơi hợp lý",
                  content:
                      "Bạn đã nằm nghỉ $duration phút vào $date. Hãy tiếp tục chăm sóc sức khỏe của mình!",
                  timestamp: groupStart!,
                );
              }
              break;
            case 5:
              notification = ActivityNotification(
                title: "🏃 Tuyệt vời! Bạn đã chạy bộ",
                content:
                    "Chạy từ ${DateFormat.Hm().format(groupStart!)} đến ${DateFormat.Hm().format(groupEnd!)} vào $date. Giữ vững phong độ nhé!",
                timestamp: groupStart!,
              );
              break;
            case 6:
              notification = ActivityNotification(
                title: "🧗 Bạn thật chăm chỉ!",
                content:
                    "Bạn đã leo cầu thang vào $date lúc ${DateFormat.Hm().format(groupStart!)}. Đây là bài tập tuyệt vời cho sức khỏe!",
                timestamp: groupStart!,
              );
              break;
            case 7:
              notification = ActivityNotification(
                title: "🚴 Bạn đã đạp xe",
                content:
                    "Từ ${DateFormat.Hm().format(groupStart!)} đến ${DateFormat.Hm().format(groupEnd!)} vào $date. Cố gắng duy trì nhé!",
                timestamp: groupStart!,
              );
              break;
          }

          if (notification != null) {
            notifications.add(notification);
          }

          currentActivity = null;
          groupStart = null;
          groupEnd = null;
        }

        for (var item in recordList) {
          final activity = int.tryParse(item['activityType'].toString());
          final start = DateTime.parse(item['start_time']);
          final end = DateTime.parse(item['end_time']);

          if (currentActivity == null) {
            currentActivity = activity;
            groupStart = start;
            groupEnd = end;
          } else if (activity == currentActivity &&
              start.difference(groupEnd!).inSeconds <= 20) {
            groupEnd = end;
          } else {
            handleGroup();
            currentActivity = activity;
            groupStart = start;
            groupEnd = end;
          }
        }

        handleGroup();
      }

      notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return notifications;
    });
  }

  Stream<List<ActivityNotification>> listenToLocations(String userId) {
    final ref = FirebaseDatabase.instance.ref("location");
    log("Listening to locations...");
    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      log("Location data changed (services): ${snapshot.value}");
      List<ActivityNotification> notifications = [];

      if (!snapshot.exists) return notifications;

      final data = Map<String, dynamic>.from(snapshot.value as Map);

      for (final entry in data.entries) {
        final record = Map<String, dynamic>.from(entry.value);

        if (record['user_id'] != userId) continue;

        final groupStart = DateTime.parse(record['start_time']);
        final date = DateFormat('dd/MM/yyyy').format(groupStart);
        double lat = record['latitude'];
        double long = record['longitude'];

        void handleGroup() {
          ActivityNotification? notification;

          notification = ActivityNotification(
            title: "🚨 Cảnh báo té ngã!",
            content:
                "Phát hiện một cú ngã vào $date lúc ${DateFormat.Hm().format(groupStart)}. Hãy kiểm tra vị trí!",
            timestamp: groupStart,
            data: LatLng(lat, long),
          );

          notifications.add(notification);
          NotificationLocalService.show(
            "🚨 Cảnh báo té ngã!",
            "Phát hiện một cú ngã vào $date lúc ${DateFormat.Hm().format(groupStart)}. Nhấn để xem vị trí.",
            payload: "fall:$lat:$long",
          );
        }

        handleGroup();
      }

      notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return notifications;
    });
  }

  Stream<List<ActivityNotification>> mergedNotifications(String userId) {
    final activityStream = listenToActivities(userId);
    final locationStream = listenToLocations(userId);

    return Rx.combineLatest2<
      List<ActivityNotification>,
      List<ActivityNotification>,
      List<ActivityNotification>
    >(activityStream, locationStream, (activityNoti, locationNoti) {
      final all = [...activityNoti, ...locationNoti];
      all.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return all;
    });
  }
}
