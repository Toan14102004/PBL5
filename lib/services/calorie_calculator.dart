import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class CalorieCalculator {
  final String userId;

  CalorieCalculator({required this.userId});

  double getMET(String activityType) {
    switch (activityType) {
      case "1":
        return 3.8;
      case "2":
        return 1.3;
      case "3":
        return 1.5;
      case "4":
        return 1.0;
      case "5":
        return 8.0;
      case "6":
        return 4.0;
      case "7":
        return 6.8;
      case "8":
        return 0.0;
      default:
        return 1.0;
    }
  }

  double calculateCalories(DateTime start, DateTime end, String activityType, double weightKg) {
    final durationSeconds = end.difference(start).inSeconds;
    final met = getMET(activityType);
    return (met * weightKg * durationSeconds) / 3600;
  }

  Future<double> fetchAndCalculateAndUpload() async {
    final today = DateFormat('dd/MM/yyyy').format(DateTime.now());


    // 1. Lấy cân nặng
    final weightRef = FirebaseDatabase.instance.ref("user/$userId/weight");
    final weightSnapshot = await weightRef.get();

    if (!weightSnapshot.exists) {
      log(' Không tìm thấy cân nặng cho user $userId');
      return 0.0;
    }

    final weightKg = double.tryParse(weightSnapshot.value.toString()) ?? 0.0;
    log(' Cân nặng của user: $weightKg kg');

    // 2. Lấy dữ liệu activity_records
    final dbRef = FirebaseDatabase.instance.ref("activity_records");
    final snapshot = await dbRef.get();

    if (!snapshot.exists) {
      log(' Không tìm thấy dữ liệu hoạt động trong Realtime Database.');
      return 0.0;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    double todayKcal = 0.0;

    for (final entry in data.entries) {
      final dayData = Map<String, dynamic>.from(entry.value);

      if (dayData['user_id'] != userId) continue;
      if (dayData['date'] != today) continue;

      final String date = dayData['date'];
      final recordsList = List<Map<dynamic, dynamic>>.from(dayData['records']);

      for (var record in recordsList) {
        final start = DateTime.parse(record['start_time']);
        final end = DateTime.parse(record['end_time']);
        final activityType = record['activityType'].toString();
        final kcal = calculateCalories(start, end, activityType, weightKg);
        todayKcal += kcal;

        final duration = end.difference(start).inSeconds;

        log(' $today | Activity: $activityType | Start: $start | End: $end | kcal: ${kcal.toStringAsFixed(2)}');
      }
    }

    // 3. Chỉ upload kcal cho ngày hôm nay
    final ref = FirebaseDatabase.instance.ref("daily_calories/$userId/$today");
    await ref.set({
      "user_id": userId,
      "date": today,
      "calories": todayKcal,
    });

    log('Đã upload kcal cho ngày hôm nay $today: ${todayKcal.toStringAsFixed(2)} kcal');

    return todayKcal;
  }

  Future<int> calculateAndUploadTotalMovingTime() async {
    final today = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final dbRef = FirebaseDatabase.instance.ref("activity_records");
    final snapshot = await dbRef.get();

    if (!snapshot.exists) {
      log('Không tìm thấy dữ liệu hoạt động.');
      return 0;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    int totalMovingSeconds = 0;

    for (final entry in data.entries) {
      final dayData = Map<String, dynamic>.from(entry.value);

      if (dayData['user_id'] != userId || dayData['date'] != today) continue;

      final recordsList = List<Map<dynamic, dynamic>>.from(dayData['records']);
      for (var record in recordsList) {
        final activityType = record['activityType'].toString();
        if (["1","3", "5", "7"].contains(activityType)) {
          final start = DateTime.parse(record['start_time']);
          final end = DateTime.parse(record['end_time']);
          final duration = end.difference(start).inSeconds;
          totalMovingSeconds += duration;
        }
      }
    }

    // Cập nhật thời gian di chuyển lên Firebase
    final moveRef = FirebaseDatabase.instance.ref("daily_movement/$userId/$today");
    await moveRef.set({
      "user_id": userId,
      "date": today,
      "total_moving_time_seconds": totalMovingSeconds,
    });

    log('✅ Tổng thời gian di chuyển hôm nay: $totalMovingSeconds giây');
    return totalMovingSeconds;
  }
}
