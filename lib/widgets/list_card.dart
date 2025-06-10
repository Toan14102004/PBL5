import 'dart:developer';
import 'dart:async';

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
    6: "🧗 Đi cầu thang",
    7: "🚴 Đạp xe",
    8: "⚠️ Té ngã",
  };

  final Map<int, DateTime> latestEndTimes = {};
  late final StreamSubscription<DatabaseEvent> _activitySubscription;

  @override
  void initState() {
    super.initState();
    listenToActivityChanges();
  }

  void listenToActivityChanges() {
    final dbRef = FirebaseDatabase.instance.ref();

    _activitySubscription = dbRef.onValue.listen((event) {
      final snapshot = event.snapshot;
      log("Snapshot value (realtime): ${snapshot.value}");

      if (snapshot.exists) {
        Map<int, DateTime> tempLatestEndTimes = {};

        final data = snapshot.value;
        if (data is Map && data.containsKey("activity_records")) {
          final activityRecords = data["activity_records"];
          if (activityRecords is Map) {
            activityRecords.forEach((key, value) {
              if (value is Map && value["records"] is List) {
                for (var r in value["records"]) {
                  if (r is Map &&
                      r["end_time"] != null &&
                      r["activityType"] != null) {
                    try {
                      DateTime endTime = DateTime.parse(r["end_time"]);
                      int activityType = r["activityType"];

                      if (!tempLatestEndTimes.containsKey(activityType) ||
                          endTime.isAfter(tempLatestEndTimes[activityType]!)) {
                        tempLatestEndTimes[activityType] = endTime;
                      }
                    } catch (e) {
                      log("Lỗi khi parse end_time: $e");
                    }
                  }
                }
              }
            });
          }
        }

        setState(() {
          latestEndTimes
            ..clear()
            ..addAll(tempLatestEndTimes);
        });

        log("Cập nhật realtime: $latestEndTimes");
      }
    });
  }

  String getStatusLabel(int activityType) {
    if (latestEndTimes.containsKey(activityType)) {
      final formattedTime = DateFormat('dd/MM/yyyy HH:mm:ss')
          .format(latestEndTimes[activityType]!);
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
  void dispose() {
    _activitySubscription.cancel();
    super.dispose();
  }

  @override

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    int? latestActivityType;
    DateTime? maxEndTime;

    // Tìm hoạt động gần nhất
    latestEndTimes.forEach((activityType, endTime) {
      if (maxEndTime == null || endTime.isAfter(maxEndTime!)) {
        maxEndTime = endTime;
        latestActivityType = activityType;
      }
    });

    return Column(
      children: List.generate(activityLabels.length, (index) {
        final activityType = index + 1;
        final label = activityLabels[activityType]!;

        final hasData = latestEndTimes.containsKey(activityType);
        Color bgColor;
        Color borderColor;
        Color statusColor;

        if (hasData) {
          final endTime = latestEndTimes[activityType]!;
          final diff = now.difference(endTime);

          if (activityType == latestActivityType && diff.inSeconds <= 10) {
            // CHỈ hoạt động mới nhất và trong vòng 10 giây => màu xanh
            bgColor = Colors.green.shade300;
            borderColor = Colors.green.shade700;
            statusColor = Colors.green.shade900;
          } else if (activityType == latestActivityType) {
            // Nếu là hoạt động mới nhất nhưng quá 10s => màu đỏ nhạt
            bgColor = Colors.red.shade100;
            borderColor = Colors.red.shade400;
            statusColor = Colors.red.shade700;
          } else {
            // Các hoạt động khác có dữ liệu => xanh dương nhạt
            bgColor = Colors.blue.shade100;
            borderColor = Colors.transparent;
            statusColor = Colors.black54;
          }
        } else {
          // Chưa có dữ liệu
          bgColor = Colors.blue.shade100;
          borderColor = Colors.transparent;
          statusColor = Colors.black54;
        }

        final statusLabel = getStatusLabel(activityType);

        return SizedBox(
          width: double.infinity,
          height: 80,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
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
          ),
        );
      }),
    );
  }

}
