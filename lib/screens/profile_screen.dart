import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/user.dart';
import '../services/profile_service.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedGender = "Nam";
  String _selectedBirthDate = "";
  int _selectedActivityLevel = 1;
  String imageUrl = "assets/default-avatar.png";
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final user = await ProfileService.getUserProfile(widget.userId);
    setState(() {
      _user = user;
      _nicknameController.text = user.nickname;
      _heightController.text = user.height.toString();
      _weightController.text = user.weight.toString();
      _selectedGender = user.gender;
      _selectedBirthDate = user.birthDate;
      _selectedActivityLevel = user.activityLevel;
      imageUrl = user.avatarUrl;
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      String avatarUrl = "assets/default_avatar.png";

      if (_image != null) {
        avatarUrl = await ProfileService.uploadImage(_image!, context);
      }

      User user = User(
        id: widget.userId,
        nickname: _nicknameController.text,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        gender: _selectedGender,
        birthDate: _selectedBirthDate,
        activityLevel: _selectedActivityLevel,
        avatarUrl: avatarUrl,
      );

      await ProfileService.saveProfile(user, avatarUrl);

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userId: 'user_1029357990'),
          ),
        );
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Đảm bảo ảnh đã được chọn
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Hồ sơ cá nhân")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _image != null
                              ? FileImage(_image!)
                              : (imageUrl.startsWith("http")
                                  ? NetworkImage(imageUrl)
                                  : AssetImage(imageUrl) as ImageProvider),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.blue),
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  // labelText: "Biệt danh...",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập biệt danh";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildInfoSex("Giới tính"),
              _buildInfoInput("Chiều cao (cm)", _heightController),
              _buildInfoInput("Cân nặng (kg)", _weightController),
              _buildInfoBirthDay("Ngày sinh"),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                child: const Text(
                  "Giới tính, chiều cao, cân nặng và ngày sinh được dùng để tính "
                  "các giá trị như lượng calo tiêu thụ, lượng calo nạp tối ưu và "
                  "phạm vi nhịp tim trong khi tập thể dục. Bạn không phải cung cấp "
                  "thông tin này, nhưng nếu cung cấp thì bạn sẽ nhận được các đề "
                  "xuất sức khỏe chính xác hơn.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const Text(
                "Mức độ hoạt động",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  3,
                  (index) => _buildActivityLevel(index + 1),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text("Lưu", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSex(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            items:
                ["Nam", "Nữ", "Khác"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue!;
              });
            },
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoInput(String title, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Nhập giá trị",
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vui lòng nhập $title";
              }
              if (double.tryParse(value) == null) {
                return "Chỉ nhập số";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBirthDay(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedBirthDate =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedBirthDate.isNotEmpty
                        ? _selectedBirthDate
                        : "Chọn ngày sinh",
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLevel(int level) {
    return GestureDetector(
      onTap: () => setState(() => _selectedActivityLevel = level),
      child: Column(
        children: [
          Icon(
            Icons.directions_walk,
            size: 40,
            color: _selectedActivityLevel == level ? Colors.green : Colors.grey,
          ),
          Text(
            "Mức $level",
            style: TextStyle(
              color:
                  _selectedActivityLevel == level ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
