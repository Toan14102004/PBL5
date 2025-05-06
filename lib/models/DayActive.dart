import '../models/Record.dart';

class DayActive {
  String id;
  String userId;
  String date;
  List<Record> records;

  DayActive({
    required this.id,
    required this.userId,
    required this.date,
    required this.records,
  });

  factory DayActive.fromMap(Map<String, dynamic> map) {
    return DayActive(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      date: map['date'] ?? '',
      records: (map['records'] as List)
          .map((record) => Record.fromMap(record))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date,
      'records': records.map((record) => record.toMap()).toList(),
    };
  }
}
