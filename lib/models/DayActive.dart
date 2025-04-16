// class DayActive {
//   String id;
//   String userId;
//   String date;
//
//   DayActive({
//     required this.id,
//     required this.userId,
//     required this.date,
//   });
//   // Chuyển từ Map -> Object
//   factory DayActive.fromMap(Map<String, dynamic> map, String documentId) {
//     return DayActive(
//       id: documentId,
//       userId: map['user_id'] ?? '',
//       date: map['date'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'user_id': userId,
//       'date': date,
//     };
//   }
// }


class DayActive {
  String id;
  String userId;
  String date;
  String activityType; // 🆕 Thêm field này

  DayActive({
    required this.id,
    required this.userId,
    required this.date,
    required this.activityType,
  });
// Chuyển từ Map -> Object
  factory DayActive.fromMap(Map<String, dynamic> map, String documentId) {
    return DayActive(
      id: documentId,
      userId: map['user_id'] ?? '',
      date: map['date'] ?? '',
      activityType: map['activity_type'] ?? '', // lấy từ Firebase
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date,
      'activity_type': activityType,
    };
  }
}
