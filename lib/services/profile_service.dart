import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../models/user.dart';
import 'package:path/path.dart';

class ProfileService {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static Future<User> getUserProfile(String userId) async {
    DatabaseReference reference = _database.ref("user/$userId");

    DataSnapshot snapshot = await reference.get();

    if (snapshot.exists) {
      var data = snapshot.value;

      if (data is Map) {
        log("🔥 Dữ liệu từ Firebase (user/$userId): $data");

        return User(
          id: userId,
          nickname: data['nickname'] ?? '',
          height: (data['height']?.toDouble() ?? 0.0),
          weight: (data['weight']?.toDouble() ?? 0.0),
          gender:
              data['gender'] is bool
                  ? (data['gender'] ? 'Nam' : 'Nữ')
                  : (data['gender'] ?? 'Nam'),
          birthDate: data['birthDate'] ?? '',
          activityLevel: data['activityLevel'] ?? 1,
          avatarUrl: data['avatar'] ?? "assets/default_avatar.png",
        );
      } else {
        throw Exception("User data is not in the expected format");
      }
    } else {
      throw Exception("User not found");
    }
  }

  // Lưu thông tin người dùng lên Firebase Realtime Database
  static Future<void> saveProfile(User user, String avatarUrl) async {
    try {
      // Sử dụng reference thay vì _dbRef
      DatabaseReference reference = _database.ref("user/${user.id}");
      await reference.set({
        'id': user.id,
        'nickname': user.nickname,
        'height': user.height,
        'weight': user.weight,
        'gender': user.gender,
        'birthDate': user.birthDate,
        'activityLevel': user.activityLevel,
        'avatarUrl': avatarUrl,
      });
    } catch (e) {
      log("Error saving user data: $e");
    }
  }

  static Future<String> uploadImage(File image, BuildContext context) async {
    try {
      // Tạo một tham chiếu đến Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;

      // Tạo một đường dẫn (path) duy nhất cho hình ảnh
      String fileName = basename(image.path);
      Reference storageRef = storage.ref().child("avatars/$fileName");

      // Tải hình ảnh lên Firebase Storage
      UploadTask uploadTask = storageRef.putFile(image);

      // Đợi quá trình tải lên hoàn thành
      TaskSnapshot taskSnapshot = await uploadTask;

      // Lấy URL của hình ảnh sau khi tải lên thành công
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl; // Trả về URL của hình ảnh đã tải lên
    } catch (e) {
      log("Error uploading image: $e");
      return ''; // Trả về null nếu có lỗi
    }
  }
}
