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
  factory Record.fromMap(Map<String, dynamic> map) {
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
}
