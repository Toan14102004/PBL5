import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex; // xác định mục(tab) nào được chọn
  final Function(int) onTap;

   // hàm được gọi khi người dùng chọn 1 mục ở thanh sidebar
  // và hàm nhận giá trị int tương ứng với chỉ mục được chọn

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});
//super.key: Cho phép sử dụng key trong StatelessWidget để tối ưu widget tree.
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        // BottomNavigationBarItem(icon: Icon(Icons.people), label: "Together"),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Fitness"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "My page"), // Thêm nút Profile
        BottomNavigationBarItem(icon:Icon(Icons.notifications),label : "Notifi" ),
      ],
    );
  }
}
