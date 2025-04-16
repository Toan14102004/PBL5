class Record {
  String id;
  String startTime;
  String endTime;
  String dayActiveId;
  String activity;

  Record({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.dayActiveId,
    required this.activity,
  });

  // Chuyển từ Map -> Object
  factory Record.fromMap(Map<String, dynamic> map, String documentId) {
    return Record(
      id: documentId,
      startTime: map['start_time'] ?? '',
      endTime: map['end_time'] ?? '',
      dayActiveId: map['id_DayActive'] ?? '',
      activity: map['activity'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start_time': startTime,
      'end_time': endTime,
      'id_DayActive': dayActiveId,
      'activity': activity,
    };
  }
}
