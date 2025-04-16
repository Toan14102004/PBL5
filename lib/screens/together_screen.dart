// import 'package:flutter/material.dart';
//
// class TogetherPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         title: Text("Chia sẻ hoạt động", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView( // ✅ Thêm cuộn nếu nội dung quá dài
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20),
//               Center(
//                 child: Icon(Icons.supervised_user_circle, size: 80, color: Colors.purpleAccent), // Biểu tượng giống ảnh
//               ),
//               SizedBox(height: 20),
//               _buildSectionTitle("Bạn nắm quyền kiểm soát"),
//               _buildSectionContent(
//                   "Cập nhật tình trạng sức khỏe của bạn với gia đình và bạn bè bằng cách chia sẻ bảo mật dữ liệu Sức khỏe của bạn.",
//                   Icons.check_circle_outline),
//               _buildSectionTitle("Bảng điều khiển và thông báo"),
//               _buildSectionContent(
//                   "Dữ liệu mà bạn chia sẻ sẽ xuất hiện trong ứng dụng Sức khỏe của họ. Họ cũng có thể nhận được thông báo nếu có bản cập nhật.",
//                   Icons.notifications),
//               _buildSectionTitle("Riêng tư và bảo mật"),
//               _buildSectionContent(
//                   "Chỉ có phần tóm tắt của từng chủ đề được chia sẻ, chứ không phải chi tiết. Thông tin được mã hóa và bạn có thể dừng chia sẻ bất kỳ lúc nào.",
//                   Icons.lock),
//               SizedBox(height: 30),
//               _buildMainButton("Chia sẻ với người khác", Colors.blue),
//               SizedBox(height: 10),
//               _buildMainButton("Đề nghị người nào đó chia sẻ", Colors.grey.shade800),
//               SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20, bottom: 5),
//       child: Text(
//         title,
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildSectionContent(String content, IconData icon) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: Colors.blue, size: 22),
//         SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             content,
//             style: TextStyle(fontSize: 14, color: Colors.white70),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMainButton(String text, Color color) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           padding: EdgeInsets.symmetric(vertical: 15),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
//       ),
//     );
//   }
// }
