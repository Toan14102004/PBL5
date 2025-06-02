import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ListCard extends StatefulWidget {
  const ListCard({super.key});

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  final Map<int, String> activityLabels = {
    1: "🚶 Đi bộ",
    2: "🧘 Ngồi",
    3: "🐥 Đứng",
    4: "🛌 Nằm",
    5: "🏃 Chạy bộ",
    6: "🧘 Đi cầu thang",
    7: "🚴 Đạp xe",
    8: "⚠️ Té ngã",
  };

  // Lưu end_time gần nhất cho từng activityType
  final Map<int, DateTime> latestEndTimes = {};

  @override
  void initState() {
    super.initState();
    fetchLatestActivities();
  }

  void fetchLatestActivities() async {
    try {
      final dbRef = FirebaseDatabase.instance.ref();
      final snapshot = await dbRef.get();
      print("Snapshot value: ${snapshot.value}");

      if (snapshot.exists) {
        // Mỗi activityType giữ record có end_time lớn nhất
        Map<int, DateTime> tempLatestEndTimes = {};

        final data = snapshot.value;
        if (data is Map && data.containsKey("activity_records")) {
          final activityRecords = data["activity_records"];
          if (activityRecords is Map) {
            activityRecords.forEach((key, value) {
              if (value is Map && value["records"] is List) {
                for (var r in value["records"]) {
                  if (r is Map && r["end_time"] != null && r["activityType"] != null) {
                    try {
                      DateTime endTime = DateTime.parse(r["end_time"]);
                      int activityType = r["activityType"];

                      // Nếu chưa có hoặc tìm được end_time mới hơn thì cập nhật
                      if (!tempLatestEndTimes.containsKey(activityType) ||
                          endTime.isAfter(tempLatestEndTimes[activityType]!)) {
                        tempLatestEndTimes[activityType] = endTime;
                      }
                    } catch (e) {
                      print("Lỗi khi parse end_time: $e");
                    }
                  }
                }
              }
            });
          }
        }

        setState(() {
          latestEndTimes.clear();
          latestEndTimes.addAll(tempLatestEndTimes);
        });

        print("Latest end times by activity: $latestEndTimes");
      } else {
        print("Snapshot không tồn tại");
      }
    } catch (e) {
      print("Lỗi khi fetch activity: $e");
    }
  }

  String getStatusLabel(int activityType) {
    if (latestEndTimes.containsKey(activityType)) {
      final formattedTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(latestEndTimes[activityType]!);
      return "Kết thúc lúc: $formattedTime";
    }
    return "Chưa có dữ liệu";
  }


  Color getStatusColor(int activityType) {
    if (latestEndTimes.containsKey(activityType)) {
      return Colors.green.shade800;
    }
    return Colors.black54;
  }

  @override
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Tìm activity có end_time lớn nhất (gần đây nhất)
    int? latestActivityType;
    DateTime? maxEndTime;

    latestEndTimes.forEach((activityType, endTime) {
      if (maxEndTime == null || endTime.isAfter(maxEndTime!)) {
        maxEndTime = endTime;
        latestActivityType = activityType;
      }
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: activityLabels.length,
      itemBuilder: (context, index) {
        final activityType = index + 1;
        final label = activityLabels[activityType]!;

        final hasData = latestEndTimes.containsKey(activityType);

        Color bgColor;
        Color borderColor;
        Color statusColor;

        if (hasData) {
          final endTime = latestEndTimes[activityType]!;
          final diff = now.difference(endTime);

          if (diff.inSeconds <= 10) {
            // Đang diễn ra: màu xanh
            bgColor = Colors.green.shade300;
            borderColor = Colors.green.shade700;
            statusColor = Colors.green.shade900;
          } else if (activityType == latestActivityType) {
            // Chỉ hành động gần nhất nhưng không đang diễn ra → màu đỏ nhạt
            bgColor = Colors.red.shade100;
            borderColor = Colors.red.shade400;
            statusColor = Colors.red.shade700;
          } else {
            // Có dữ liệu nhưng không thỏa 2 điều trên → xám nhạt
            bgColor = Colors.blue.shade100;
            borderColor = Colors.transparent;
            statusColor = Colors.black54;
          }
        } else {
          // Không có dữ liệu → xám nhạt
          // bgColor = Colors.grey.shade200;
          bgColor = Colors.blue.shade100;
          borderColor = Colors.transparent;
          statusColor = Colors.black54;
        }

        final statusLabel = getStatusLabel(activityType);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
