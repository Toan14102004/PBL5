import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../models/record.dart';

class PieChartScreen extends StatelessWidget {
  final String userId;
  const PieChartScreen({super.key, required this.userId});

  Future<List<Record>> fetchRecordsFromFirebase(String userId) async {
    final ref = FirebaseDatabase.instance.ref("activity_records");
    final snapshot = await ref.get();

    List<Record> records = [];

    if (snapshot.exists) {
      // log("📦 Firebase data: ${snapshot.value}");

      final data = Map<String, dynamic>.from(snapshot.value as Map);

      final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
      // log(" Ngày hôm nay: $today");

      for (final entry in data.entries) {
        final recordMap = Map<String, dynamic>.from(entry.value);

        final recordUserId = recordMap['user_id'];
        final recordDate = recordMap['date'];

        // log("Checking: user=${recordUserId}, date=$recordDate");

        if (recordUserId != userId || recordDate != today) continue;

        final recordItems = List.from(recordMap['records'] ?? []);

        for (var item in recordItems) {
          final itemMap = Map<String, dynamic>.from(item);

          // Lấy activityType từ Firebase có thể là int hoặc String
          dynamic rawActivityType = itemMap['activityType'];

          // Chuyển sang String nếu cần
          String activityTypeStr = rawActivityType.toString();

          // Tạo đối tượng Record với activityType là String
          var r = Record.fromMap({
            ...itemMap,
            'activityType': activityTypeStr,
          });

          int typeInt = int.tryParse(activityTypeStr) ?? 0;
          String activityName = Record.activityTypeToName(typeInt);
          // log(" activityType $typeInt mapped to $activityName");

          // Tạo lại Record với activityType đã map thành tên hoạt động
          r = Record(
            startTime: r.startTime,
            endTime: r.endTime,
            dayActiveId: r.dayActiveId,
            activityType: activityName,
          );

          log(" Record hôm nay: ${r.activityType} | ${r.startTime} → ${r.endTime}");

          records.add(r);
        }

      }
    } else {
      log(" Không có dữ liệu trong Firebase.");
    }

    log(" Tổng số bản ghi hôm nay: ${records.length}");
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Biểu đồ hoạt động")),
      body: FutureBuilder<List<Record>>(
        future: fetchRecordsFromFirebase(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Không có dữ liệu hoạt động cho hôm nay."),
            );
          }

          return PieChartWidget(records: snapshot.data!);
        },
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final List<Record> records;
  const PieChartWidget({super.key, required this.records});

  List<PieChartSectionData> createChartSectionsFromRecords(List<Record> records) {
    Map<String, Duration> activityDurations = {};
    for (var record in records) {
      DateTime? start = DateTime.tryParse(record.startTime);
      DateTime? end = DateTime.tryParse(record.endTime);

      if (start != null && end != null && end.isAfter(start)) {
        Duration duration = end.difference(start);
        activityDurations[record.activityType] =
            (activityDurations[record.activityType] ?? Duration()) + duration;
      }
    }

    Duration totalDuration = activityDurations.values.fold(Duration.zero, (sum, dur) => sum + dur);

    if (totalDuration.inSeconds == 0) return [];

    Map<String, Color> colorMap = {
      "Đi bộ": Colors.green,
      "Chạy bộ": Colors.blue,
      "Đạp xe": Colors.yellow,
      "Ngồi": Colors.orange,
      "Nằm": Colors.pink,
      "Đứng": Colors.purple,
      "Leo cầu thang": Colors.brown,
      "Ngã": Colors.red,
      "Không xác định": Colors.grey.shade400,
    };

    // Tính phần trăm thô
    Map<String, double> rawPercents = {};
    activityDurations.forEach((activity, duration) {
      rawPercents[activity] = duration.inSeconds / totalDuration.inSeconds * 100;
    });

    // Áp dụng min 1% cho phần trăm nhỏ
    Map<String, double> adjustedPercents = {};
    rawPercents.forEach((activity, percent) {
      if (percent > 0 && percent < 1) {
        adjustedPercents[activity] = 1;
      } else {
        adjustedPercents[activity] = percent;
      }
    });

    // Tính tổng phần trăm đã điều chỉnh
    double adjustedTotal = adjustedPercents.values.fold(0, (a, b) => a + b);

    // Nếu tổng > 100%, cần chuẩn hóa lại để tổng = 100%
    if (adjustedTotal > 100) {
      // Tìm phần trăm lớn nhất để giảm bớt
      String maxActivity = adjustedPercents.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      double excess = adjustedTotal - 100;

      adjustedPercents[maxActivity] = adjustedPercents[maxActivity]! - excess;
    }

    // Tạo danh sách section cho PieChart
    List<PieChartSectionData> sections = [];
    adjustedPercents.forEach((activity, percent) {
      sections.add(PieChartSectionData(
        color: colorMap[activity] ?? Colors.grey,
        value: percent,
        title: "${percent.toStringAsFixed(0)}%",
        radius: 60,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ));
    });

    return sections;
  }
  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = createChartSectionsFromRecords(records);

    if (sections.isEmpty) {
      return const Center(
        child: Text(
          'Dữ liệu đang được cập nhật\nXin bạn chờ trong giây lát...',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }
}
