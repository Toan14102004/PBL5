class GPS {
  String location;
  String dayActiveId;

  GPS({
    required this.location,
    required this.dayActiveId,
  });

  // Chuyển từ Map -> Object
  factory GPS.fromMap(Map<String, dynamic> map) {
    return GPS(
      location: map['location'] ?? '',
      dayActiveId: map['id_DayActive'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'id_DayActive': dayActiveId,
    };
  }
}
