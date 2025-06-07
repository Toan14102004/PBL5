import 'day_active.dart';

class User {
  String id;
  String nickname;
  double height;
  double weight;
  String gender;
  String birthDate;
  int activityLevel;
  // File? avatarUrl;
  final String avatarUrl; // phải là String


  List<DayActive>? dayActivities;

  User({
    required this.id,
    required this.nickname,
    required this.height,
    required this.weight,
    required this.gender,
    required this.birthDate,
    required this.activityLevel,
    // this.avatarUrl,
    required this.avatarUrl,
    this.dayActivities,
  });
  // Chuyển từ Map -> Object
  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    return User(
      id: documentId,
      nickname: data['nickname'],
      height: data['height'].toDouble(),
      weight: data['weight'].toDouble(),
      gender: data['gender'],
      birthDate: data['birthDate'],
      activityLevel: data['activityLevel'],
      avatarUrl: data['avatarUrl'],
      dayActivities: data['dayActivities'] != null
          ? (data['dayActivities'] as List)
          .map((day) => DayActive.fromMap(day))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'height': height,
      'weight': weight,
      'gender': gender,
      'birthDate': birthDate,
      'activityLevel': activityLevel,
      'avatarUrl': avatarUrl,
      'dayActivities': dayActivities?.map((day) => day.toMap()).toList(),
    };
  }
}
