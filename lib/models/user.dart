// import 'dart:io';
//
// class User {
//   String id;
//   String nickname;
//   double height;
//   double weight;
//   String gender;
//   String birthDate;
//   int activityLevel;
//   File? avatarUrl; // Lưu URL ảnh thay vì File
//
//   User({
//     required this.id,
//     required this.nickname,
//     required this.height,
//     required this.weight,
//     required this.gender,
//     required this.birthDate,
//     required this.activityLevel,
//     this.avatarUrl,
//   });
//
//   // Chuyển từ Map -> Object
//   factory User.fromMap(Map<String, dynamic> data, String documentId) {
//     return User(
//       id: documentId,
//       nickname: data['nickname'],
//       height: data['height'].toDouble(),
//       weight: data['weight'].toDouble(),
//       gender: data['gender'],
//       birthDate: data['birthDate'],
//       activityLevel: data['activityLevel'],
//       avatarUrl: data['avatarUrl'],
//     );
//   }
//
//   // Chuyển từ Object -> Map
//   Map<String, dynamic> toMap() {
//     return {
//       'nickname': nickname,
//       'height': height,
//       'weight': weight,
//       'gender': gender,
//       'birthDate': birthDate,
//       'activityLevel': activityLevel,
//       'avatarUrl': avatarUrl,
//     };
//   }
// }


import 'dart:io';
import 'DayActive.dart';

class User {
  String id;
  String nickname;
  double height;
  double weight;
  String gender;
  String birthDate;
  int activityLevel;
  File? avatarUrl;

  List<DayActive>? dayActivities;

  User({
    required this.id,
    required this.nickname,
    required this.height,
    required this.weight,
    required this.gender,
    required this.birthDate,
    required this.activityLevel,
    this.avatarUrl,
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
