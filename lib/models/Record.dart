class Record {

  String startTime;
  String endTime;
  String dayActiveId;
  String activityType;

  Record({
    required this.startTime,
    required this.endTime,
    required this.dayActiveId,
    required this.activityType,
  });

  // Chuyển từ Map -> Object
  factory Record.fromMap(Map<dynamic, dynamic> map) {
    return Record(
      // id: documentId,
      startTime: map['start_time'] ?? '',
      endTime: map['end_time'] ?? '',
      dayActiveId: map['id_DayActive'] ?? '',
      activityType: map['activityType'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start_time': startTime,
      'end_time': endTime,
      'id_DayActive': dayActiveId,
      'activityType': activityType,
    };
  }
  static String activityTypeToName(int type) {
    switch (type) {
      case 1: return "Đi bộ";
      case 2: return "Ngồi";
      case 3: return "Đứng";
      case 4: return "Nằm";
      case 5: return "Chạy bộ";
      case 6: return "Leo cầu thang";
      case 7: return "Đạp xe";
      case 8: return "Ngã";
      default: return "Không xác định";
    }
  }
}
