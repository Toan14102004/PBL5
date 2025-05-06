import 'package:flutter/material.dart';

class IdYteScreen extends StatefulWidget {
  const IdYteScreen({Key? key}) : super(key: key);

  @override
  State<IdYteScreen> createState() => _IdYteScreenState();
}

class _IdYteScreenState extends State<IdYteScreen> {
  final TextEditingController allergyController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();
  Map<String, dynamic> userInfo = {};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/id_yte.png',
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'ID Y Tế',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Container(
        color: Colors.blue.shade50,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text("📄 Thông tin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text(
              "Dị ứng & phản ứng",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: allergyController,
                decoration: const InputDecoration(
                  labelText: "Liệt kê...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Thêm nhóm máu",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bloodGroupController,
              decoration: const InputDecoration(
                labelText: "Nhóm máu...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Thêm nhịp tim",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: heartRateController,
              decoration: const InputDecoration(
                labelText: "0 bpm...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            const Text("📞 Liên hệ khẩn cấp", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: emergencyContactController,
              decoration: const InputDecoration(
                labelText: "Thêm liên hệ khẩn cấp...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Căn chỉnh nút => phải
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Lưu thông tin vào Map
                    setState(() {
                      userInfo = {
                        'allergy': allergyController.text,
                        'bloodGroup': bloodGroupController.text,
                        'heartRate': heartRateController.text,
                        'emergencyContact': emergencyContactController.text,
                      };
                    });

                    // Hiển thị AlertDialog
                    showDialog(
                      context: context,
                      barrierDismissible: false, // Không cho bấm ra ngoài để tắt
                      builder: (BuildContext context) {
                        // Sau 2 giây thì tự tắt dialog và quay lại
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).pop(); // đóng dialog
                          Navigator.of(context).pop(); // quay lại trang trước
                        });

                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text('🎉 Cập nhật thành công!'),
                          content: const Text('Thông tin của bạn đã được lưu.'),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text('Cập nhật'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
