import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../models/activity_notification.dart';
import '../models/user.dart';


class MoveTimeService {
  Future<List<ActivityNotification>> fetchAllRecordFromActivities(String userId) async {
    final ref = FirebaseDatabase.instance.ref("activity_records");
    final snapshot = await ref.get();


    List<ActivityNotification> notifications = [];

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      for (final entry in data.entries) {
        final record = Map<String, dynamic>.from(entry.value);

        if (record['user_id'] != userId) continue;

        final date = record['date'];
        final records = Map<String, dynamic>.from(record['records']);

        for (var item in records.values) {
          final activityType = item['activityType'];
          final startTime = DateTime.parse(item['start_time']);
          final endTime = DateTime.parse(item['end_time']);
          final duration = endTime.difference(startTime).inMinutes;

          ActivityNotification? notification;

          switch (activityType) {
            case 1: // Đi bộ
              notification = ActivityNotification(
                title: "🚶 Bạn đã đi bộ",
                content: "Đi bộ từ ${DateFormat.Hm().format(startTime)} đến ${DateFormat.Hm().format(endTime)} vào $date. Tiếp tục vận động nhé!",
                timestamp: startTime,
              );
              break;

            case 2: // Ngồi
              if (duration >= 120) {
                notification = ActivityNotification(
                  title: '⏳ Ngồi quá lâu!',
                  content: 'Bạn đã ngồi liên tục ${duration ~/ 60} giờ vào $date. Hãy đứng dậy và vận động nhẹ nhé!',
                  timestamp: startTime,
                );
              }
              break;

            case 3: // Đứng
              if (duration >= 30) {
                notification = ActivityNotification(
                  title: "🧍 Bạn đã đứng khá lâu",
                  content: "Bạn đã đứng khoảng ${duration} phút vào $date. Hãy nghỉ ngơi nếu thấy mỏi nhé!",
                  timestamp: startTime,
                );
              }
              break;

            case 4: // Nằm
              if (duration >= 10 && duration <= 60) {
                notification = ActivityNotification(
                  title: "🛏️ Nghỉ ngơi hợp lý",
                  content: "Bạn đã nằm nghỉ ${duration} phút vào $date. Hãy tiếp tục chăm sóc sức khỏe của mình!",
                  timestamp: startTime,
                );
              }
              break;

            case 5: // Chạy bộ
              notification = ActivityNotification(
                title: "🏃 Tuyệt vời! Bạn đã chạy bộ",
                content: "Chạy từ ${DateFormat.Hm().format(startTime)} đến ${DateFormat.Hm().format(endTime)} vào $date. Giữ vững phong độ nhé!",
                timestamp: startTime,
              );
              break;

            case 6: // Đi cầu thang
              notification = ActivityNotification(
                title: "🧗 Bạn thật chăm chỉ!",
                content: "Bạn đã leo cầu thang vào $date lúc ${DateFormat.Hm().format(startTime)}. Đây là bài tập tuyệt vời cho sức khỏe!",
                timestamp: startTime,
              );
              break;

            case 7: // Đạp xe
              notification = ActivityNotification(
                title: "🚴 Bạn đã đạp xe",
                content: "Bạn đã đạp xe từ ${DateFormat.Hm().format(startTime)} đến ${DateFormat.Hm().format(endTime)} vào $date. Cố gắng duy trì nhé!",
                timestamp: startTime,
              );
              break;

            case 8: // Ngã
              notification = ActivityNotification(
                title: "🚨 Cảnh báo té ngã!",
                content: "Phát hiện một cú ngã vào $date lúc ${DateFormat.Hm().format(startTime)}. Hãy kiểm tra tình trạng của bạn.",
                timestamp: startTime,
              );
              break;
          }

          if (notification != null) {
            notifications.add(notification);
            print("[NOTIFY] ${notification.title} - ${notification.content}");
          }
        }
      }
    }

    // return notifications.reversed.toList();
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return notifications;

  }
}
