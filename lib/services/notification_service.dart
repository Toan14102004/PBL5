// 1 : Đi bộ
// 2 : Ngồi
// 3 : Đứng
// 4 : Nằm
// 5 : Chạy bộ
// 6 : Đi cầu thang
// 7 : Đạp xe
// 8 : Ngã
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../models/activity_notification.dart';

class NotificationService {
  //handleGroup() xử lý mỗi chuỗi liên tục (gộp nhiều record)
  //if (start.difference(groupEnd!).inSeconds <= 20) cho phép 2 record cách nhau tối đa 20s vẫn tính là liên tục
  Future<List<ActivityNotification>> fetchNotificationsFromActivities(String userId) async {
    final ref = FirebaseDatabase.instance.ref("activity_records");
    final snapshot = await ref.get();

    List<ActivityNotification> notifications = [];

    if (!snapshot.exists) return notifications;

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    for (final entry in data.entries) {
      final record = Map<String, dynamic>.from(entry.value);

      if (record['user_id'] != userId) continue;

      final date = record['date'];
      final recordList = List<Map<dynamic, dynamic>>.from(record['records']);

      // Sắp xếp theo thời gian bắt đầu
      recordList.sort((a, b) => DateTime.parse(a['start_time']).compareTo(DateTime.parse(b['start_time'])));

      // Gom các record liên tiếp cùng activityType
      int? currentActivity;
      DateTime? groupStart;
      DateTime? groupEnd;

      void handleGroup() {
        if (currentActivity == null || groupStart == null || groupEnd == null) return;
        final duration = groupEnd!.difference(groupStart!).inMinutes;

        ActivityNotification? notification;

        switch (currentActivity) {
          case 1:
            notification = ActivityNotification(
              title: "🚶 Bạn đã đi bộ",
              content: "Từ ${DateFormat.Hm().format(groupStart!)} đến ${DateFormat.Hm().format(groupEnd!)} vào $date. Tiếp tục vận động nhé!",
              timestamp: groupStart!,
            );
            break;
          case 2:
            if (duration >= 120) {
              notification = ActivityNotification(
                title: '⏳ Ngồi quá lâu!',
                content: 'Bạn đã ngồi liên tục ${duration ~/ 60} giờ vào $date. Hãy đứng dậy và vận động nhẹ nhé!',
                timestamp: groupStart!,
              );
            }
            break;
          case 3:
            if (duration >= 30) {
              notification = ActivityNotification(
                title: "🧍 Bạn đã đứng khá lâu",
                content: "Bạn đã đứng khoảng ${duration} phút vào $date. Hãy nghỉ ngơi nếu thấy mỏi nhé!",
                timestamp: groupStart!,
              );
            }
            break;
          case 4:
            if (duration >= 10 && duration <= 60) {
              notification = ActivityNotification(
                title: "🛏️ Nghỉ ngơi hợp lý",
                content: "Bạn đã nằm nghỉ ${duration} phút vào $date. Hãy tiếp tục chăm sóc sức khỏe của mình!",
                timestamp: groupStart!,
              );
            }
            break;
          case 5:
            notification = ActivityNotification(
              title: "🏃 Tuyệt vời! Bạn đã chạy bộ",
              content: "Chạy từ ${DateFormat.Hm().format(groupStart!)} đến ${DateFormat.Hm().format(groupEnd!)} vào $date. Giữ vững phong độ nhé!",
              timestamp: groupStart!,
            );
            break;
          case 6:
            notification = ActivityNotification(
              title: "🧗 Bạn thật chăm chỉ!",
              content: "Bạn đã leo cầu thang vào $date lúc ${DateFormat.Hm().format(groupStart!)}. Đây là bài tập tuyệt vời cho sức khỏe!",
              timestamp: groupStart!,
            );
            break;
          case 7:
            notification = ActivityNotification(
              title: "🚴 Bạn đã đạp xe",
              content: "Từ ${DateFormat.Hm().format(groupStart!)} đến ${DateFormat.Hm().format(groupEnd!)} vào $date. Cố gắng duy trì nhé!",
              timestamp: groupStart!,
            );
            break;
          case 8:
            notification = ActivityNotification(
              title: "🚨 Cảnh báo té ngã!",
              content: "Phát hiện một cú ngã vào $date lúc ${DateFormat.Hm().format(groupStart!)}. Hãy kiểm tra tình trạng của bạn.",
              timestamp: groupStart!,
            );
            break;
        }

        if (notification != null) {
          notifications.add(notification);
          print("[NOTIFY] ${notification.title} - ${notification.content}");
        }

        // Reset
        currentActivity = null;
        groupStart = null;
        groupEnd = null;
      }

      for (var item in recordList) {
        final activity = int.tryParse(item['activityType'].toString());
        final start = DateTime.parse(item['start_time']);
        final end = DateTime.parse(item['end_time']);

        if (currentActivity == null) {
          // Bắt đầu group mới
          currentActivity = activity;
          groupStart = start;
          groupEnd = end;
        } else if (activity == currentActivity && start.difference(groupEnd!).inSeconds <= 20) {
          // Tiếp tục chuỗi liên tục (chấp nhận 10s khoảng cách, tối đa 20s)
          groupEnd = end;
        } else {
          // Kết thúc chuỗi hiện tại, xử lý, rồi bắt đầu chuỗi mới
          handleGroup();
          currentActivity = activity;
          groupStart = start;
          groupEnd = end;
        }
      }

      // Xử lý chuỗi cuối cùng
      handleGroup();
    }

    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return notifications;
  }

}
