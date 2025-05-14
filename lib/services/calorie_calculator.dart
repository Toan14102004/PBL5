import 'package:firebase_database/firebase_database.dart';

class CalorieCalculator {
  final String userId;

  CalorieCalculator({required this.userId});

  // Lấy MET theo mã hoạt động
  double getMET(String activityType) {
    switch (activityType) {
      case "1":
        return 3.8; // Đi bộ
      case "2":
        return 1.3; // Ngồi
      case "3":
        return 1.5; // Đứng
      case "4":
        return 1.0; // Nằm
      case "5":
        return 8.0; // Chạy bộ
      case "6":
        return 4.0; // Đi cầu thang
      case "7":
        return 6.8; // Đạp xe
      case "8":
        return 0.0; // Ngã
      default:
        return 1.0;
    }
  }

  // Tính kcal cho một khoảng thời gian hoạt động
  double calculateCalories(DateTime start, DateTime end, String activityType, double weightKg) {
    final durationMinutes = end.difference(start).inMinutes;
    final met = getMET(activityType);
    return (met * weightKg * durationMinutes) / 60;
  }

  Future<double> fetchAndCalculateAndUpload() async {
    double totalKcal = 0.0;

    // 1. Lấy cân nặng từ Realtime Database
    final weightRef = FirebaseDatabase.instance.ref("user/$userId/weight");
    final weightSnapshot = await weightRef.get();

    if (!weightSnapshot.exists) {
      print('❌ Không tìm thấy cân nặng cho user $userId');
      return 0.0;
    }

    final weightKg = double.tryParse(weightSnapshot.value.toString()) ?? 0.0;
    print('✅ Cân nặng của user: $weightKg kg');

    //  2. Lấy dữ liệu hoạt động từ Realtime Database
    final dbRef = FirebaseDatabase.instance.ref("activity_records");
    final snapshot = await dbRef.get();

    if (!snapshot.exists) {
      print('❌ Không tìm thấy dữ liệu hoạt động trong Realtime Database.');
      return 0.0;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    Map<String, double> kcalPerDay = {};

    for (final entry in data.entries) {
      final dayData = Map<String, dynamic>.from(entry.value);

      if (dayData['user_id'] != userId) continue;

      final String date = dayData['date'];
      // final recordsList = List<Map<String, dynamic>>.from(dayData['records']);
      final recordsMap = Map<String, dynamic>.from(dayData['records']);
      final recordsList = recordsMap.values.map((e) => Map<String, dynamic>.from(e)).toList();


      double dailyKcal = 0.0;

      for (var record in recordsList) {
        final start = DateTime.parse(record['start_time']);
        final end = DateTime.parse(record['end_time']);
        final activityType = record['activityType'].toString();
        final kcal = calculateCalories(start, end, activityType, weightKg);
        dailyKcal += kcal;

        print('📌 $date | Activity: $activityType | Start: $start | End: $end | kcal: ${kcal.toStringAsFixed(2)}');
      }

      kcalPerDay[date] = dailyKcal;
      totalKcal += dailyKcal;
      print('*** Ngày $date - Tổng kcal: ${dailyKcal.toStringAsFixed(2)}');
    }

    //3. Gửi dữ liệu lên Realtime Database tại daily_calories
    for (final entry in kcalPerDay.entries) {
      final ref = FirebaseDatabase.instance.ref("daily_calories/$userId/${entry.key}");
      await ref.set({
        "user_id": userId,
        "date": entry.key,
        "calories": entry.value,
      });
      print('📤 Đã upload kcal cho ngày ${entry.key}: ${entry.value.toStringAsFixed(2)} kcal');
    }

    print('🎯 Tổng kcal tất cả các ngày: ${totalKcal.toStringAsFixed(2)}');
    return totalKcal;
  }
}
