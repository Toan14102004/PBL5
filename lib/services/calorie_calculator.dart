import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class RealtimeResult {
  final double calories;
  final int movingTimeSeconds;

  RealtimeResult({required this.calories, required this.movingTimeSeconds});
}

class CalorieCalculator {
  final String userId;
  StreamSubscription? _activitySub;
  StreamSubscription? _weightSub;

  double _weightKg = 0.0;

  CalorieCalculator({required this.userId});

  double getMET(String activityType) {
    switch (activityType) {
      case "1": return 3.8;
      case "2": return 1.3;
      case "3": return 1.5;
      case "4": return 1.0;
      case "5": return 8.0;
      case "6": return 4.0;
      case "7": return 6.8;
      case "8": return 0.0;
      default: return 1.0;
    }
  }

  double calculateCalories(DateTime start, DateTime end, String activityType, double weightKg) {
    final durationSeconds = end.difference(start).inSeconds;
    final met = getMET(activityType);
    return (met * weightKg * durationSeconds) / 3600;
  }

  void listenToRealtime(void Function(RealtimeResult result) onData) {
    final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final weightRef = FirebaseDatabase.instance.ref("user/$userId/weight");
    final activityRef = FirebaseDatabase.instance.ref("activity_records");

    log('📡 Đăng ký lắng nghe dữ liệu từ Firebase Realtime Database');

    _weightSub = weightRef.onValue.listen((weightEvent) {


      if (!weightEvent.snapshot.exists) {
        log('⚠️ Không có dữ liệu cân nặng cho user: $userId');
        return;
      }

      final weightKg = double.tryParse(weightEvent.snapshot.value.toString()) ?? 0.0;
      log('⚖️ Cân nặng hiện tại: $weightKg kg');

      _activitySub?.cancel(); // Huỷ đăng ký cũ (nếu có)
      _activitySub = activityRef.onValue.listen((DatabaseEvent event) async {
        final snapshot = event.snapshot;
        if (!snapshot.exists) {
          log('⛔ Không có dữ liệu trong activity_records');
          return;
        }
        final dayKey = snapshot.key;
        final dayData = Map<String, dynamic>.from(snapshot.value as Map);

        // ✅ In log cho dữ liệu mới được thêm
        log('🆕 Dữ liệu mới được thêm vào activity_records tại key: $dayKey');
        log('📦 Nội dung mới: $dayData');
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        double todayKcal = 0.0;
        int totalMovingSeconds = 0;

        for (final entry in data.entries) {
          final dayData = Map<String, dynamic>.from(entry.value);

          if (dayData['user_id'] != userId) {
            log('🔄 Bỏ qua dữ liệu của user khác: ${dayData['user_id']}');
            continue;
          }

          if (dayData['date'] != today) {
            log(' Bỏ qua dữ liệu của ngày khác: ${dayData['date']}');
            continue;
          }

          final recordsList = List<Map<dynamic, dynamic>>.from(dayData['records']);
          for (var record in recordsList) {
            final start = DateTime.parse(record['start_time']);
            final end = DateTime.parse(record['end_time']);
            final activityType = record['activityType'].toString();

            final kcal = calculateCalories(start, end, activityType, weightKg);
            todayKcal += kcal;

            final duration = end.difference(start).inSeconds;
            if (["1", "3", "5", "7"].contains(activityType)) {
              totalMovingSeconds += duration;
            }

            log(' Hoạt động: $activityType, thời gian: $duration giây, kcal: ${kcal.toStringAsFixed(2)}');
          }
        }

        log('Tổng Kcal hôm nay: ${todayKcal.toStringAsFixed(2)}');
        log('Tổng thời gian di chuyển hôm nay: $totalMovingSeconds giây');

        // Gửi kết quả về qua callback
        onData(RealtimeResult(
          calories: todayKcal,
          movingTimeSeconds: totalMovingSeconds,
        ));

        // Cập nhật Firebase (nếu cần)
        final kcalRef = FirebaseDatabase.instance.ref("daily_calories/$userId/$today");
        final moveRef = FirebaseDatabase.instance.ref("daily_movement/$userId/$today");

        await kcalRef.set({
          "user_id": userId,
          "date": today,
          "calories": todayKcal,
        });

        await moveRef.set({
          "user_id": userId,
          "date": today,
          "total_moving_time_seconds": totalMovingSeconds,
        });

        // log(' Đã cập nhật dữ liệu lên Firebase cho ngày $today');
      });
    });
  }


  void dispose() {
    _activitySub?.cancel();
    _weightSub?.cancel();
  }
}
