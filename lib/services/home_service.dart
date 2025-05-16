import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ActivitiScreenService {
  String userId;
  ActivitiScreenService({required this.userId});

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

  Future<int> fetchFallActivity(String date) async {
    final ref = FirebaseDatabase.instance.ref("activity_records");
    final snapshot = await ref.get();
    int counterFall = 0;

    if (!snapshot.exists) {
      log('Không tìm thấy dữ liệu hoạt động.');
      return 0;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    data.forEach((key, value) {
      final item = Map<String, dynamic>.from(value);

      if (item['user_id'] == userId && item['date'] == date) {
        final recordsRaw = item['records'];
        if (recordsRaw is List) {
          final records = recordsRaw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          for (final record in records) {
            if (record['activityType'] == 8) {
              counterFall++;
            }
          }
        }
      }
    });

    return counterFall;
  }

  Future<double> fetchAndCalculateAndUpload(String date) async {
    log(' Ngày được truyền vào: $date');
    // 1. Lấy cân nặng
    final weightRef = FirebaseDatabase.instance.ref("user/$userId/weight");
    final weightSnapshot = await weightRef.get();

    if (!weightSnapshot.exists) {
      log('Không tìm thấy cân nặng cho user $userId');
      return 0.0;
    }

    final weightKg = double.tryParse(weightSnapshot.value.toString()) ?? 0.0;
    log('Cân nặng của user: $weightKg kg');

    // 2. Lấy dữ liệu activity_records
    final dbRef = FirebaseDatabase.instance.ref("activity_records");
    final snapshot = await dbRef.get();

    if (!snapshot.exists) {
      log('Không tìm thấy dữ liệu hoạt động trong Realtime Database.');
      return 0.0;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    double kcalOfDay = 0.0;

    for (final entry in data.entries) {
      final dayData = Map<String, dynamic>.from(entry.value);

      if (dayData['user_id'] != userId) continue;
      if (dayData['date'] != date) continue;

      final recordsList = List<Map<dynamic, dynamic>>.from(dayData['records']);

      for (var record in recordsList) {
        final start = DateTime.parse(record['start_time']);
        final end = DateTime.parse(record['end_time']);
        final activityType = record['activityType'].toString();
        final kcal = calculateCalories(start, end, activityType, weightKg);
        kcalOfDay += kcal;

        log('$date | Activity: $activityType | Start: $start | End: $end | kcal: ${kcal.toStringAsFixed(2)}');
      }
    }

    // 3. Upload kcal vào đúng ngày được truyền vào (dù là hôm nay hay quá khứ)
    final ref = FirebaseDatabase.instance.ref("daily_calories/$userId/$date");
    await ref.set({
      "user_id": userId,
      "date": date,
      "calories": kcalOfDay,
    });

    log('Đã upload kcal cho ngày $date: ${kcalOfDay.toStringAsFixed(2)} kcal');

    return kcalOfDay;
  }


  Future<int> calculateAndUploadTotalMovingTime(String date) async {

    final dbRef = FirebaseDatabase.instance.ref("activity_records");
    final snapshot = await dbRef.get();

    if (!snapshot.exists) {
      log(' Không tìm thấy dữ liệu hoạt động.');
      return 0;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    int totalMovingSeconds = 0;

    for (final entry in data.entries) {
      final dayData = Map<String, dynamic>.from(entry.value);

      if (dayData['user_id'] != userId || dayData['date'] != date) continue;

      final recordsList = List<Map<dynamic, dynamic>>.from(dayData['records']);
      for (var record in recordsList) {
        final activityType = record['activityType'].toString();

        // Chỉ tính các hoạt động được định nghĩa là "di chuyển"
        if (["1", "3", "5", "7"].contains(activityType)) {
          final start = DateTime.parse(record['start_time']);
          final end = DateTime.parse(record['end_time']);
          final duration = end.difference(start).inSeconds;
          totalMovingSeconds += duration;
        }
      }
    }

    // Cập nhật thời gian di chuyển lên Firebase cho ngày truyền vào
    final moveRef = FirebaseDatabase.instance.ref("daily_movement/$userId/$date");
    await moveRef.set({
      "user_id": userId,
      "date": date,
      "total_moving_time_seconds": totalMovingSeconds,
    });

    log('Tổng thời gian di chuyển ngày $date: $totalMovingSeconds giây');
    return totalMovingSeconds;
  }

}
