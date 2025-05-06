import '../models/Record.dart';

// Calories = (MET * Trọng lượng cơ thể (kg) * Thời gian (phút)) / 60

class CalorieCalculator {
  final double weightKg;

  CalorieCalculator({required this.weightKg});

  double getMET(String activityType) {
    switch (activityType) {
      case "Chạy bộ":
        return 8.0;
      case "Đạp xe":
        return 6.8;
      case "Đi bộ":
        return 3.8;
      case "Ngồi":
        return 1.3;
      case "Nằm":
        return 1.0;
      case "Đứng":
        return 1.5;
      default:
        return 1.0;
    }
  }

  double calculateCalories(Record record) {
    final start = DateTime.parse(record.startTime);
    final end = DateTime.parse(record.endTime);
    final durationMinutes = end.difference(start).inMinutes;
    final met = getMET(record.activityType);
    return (met * weightKg * durationMinutes) / 60;
  }

  double calculateTotalCalories(List<Record> records) {
    return records.fold(0.0, (sum, record) => sum + calculateCalories(record));
  }
}

// import 'models/record.dart';
// import 'services/calorie_calculator.dart';
//
// void main() {
//   List<Record> sampleRecords = [/*... dữ liệu như bạn đã đưa ...*/];
//
//   final calculator = CalorieCalculator(weightKg: 60);
//   double total = calculator.calculateTotalCalories(sampleRecords);
//
//   print("Tổng kcal trong ngày: ${total.toStringAsFixed(2)}");
// }
