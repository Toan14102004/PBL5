import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../models/Record.dart';

class CharOfActiveScreen extends StatelessWidget {
  final String userId;
  const CharOfActiveScreen({super.key, required this.userId});

  Stream<List<Record>> fetchRecordsStream(String userId) {
    final ref = FirebaseDatabase.instance.ref("activity_records");

    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      List<Record> records = [];

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        final today = DateFormat('dd/MM/yyyy').format(DateTime.now());

        for (final entry in data.entries) {
          final recordMap = Map<String, dynamic>.from(entry.value);

          final recordUserId = recordMap['user_id'];
          final recordDate = recordMap['date'];

          if (recordUserId != userId || recordDate != today) continue;

          final recordItems = List.from(recordMap['records'] ?? []);

          for (var item in recordItems) {
            final itemMap = Map<String, dynamic>.from(item);

            dynamic rawActivityType = itemMap['activityType'];
            String activityTypeStr = rawActivityType.toString();

            var r = Record.fromMap({
              ...itemMap,
              'activityType': activityTypeStr,
            });

            int typeInt = int.tryParse(activityTypeStr) ?? 0;
            String activityName = Record.activityTypeToName(typeInt);

            r = Record(
              startTime: r.startTime,
              endTime: r.endTime,
              dayActiveId: r.dayActiveId,
              activityType: activityName,
            );

            records.add(r);
          }
        }
      } else {
        log("Không có dữ liệu trong Firebase.");
      }

      log("Tổng số bản ghi hôm nay: ${records.length}");
      return records;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: StreamBuilder<List<Record>>(
        stream: fetchRecordsStream(userId),
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

  List<PieChartSectionData> createChartSectionsFromRecords(
      List<Record> records) {
    // Các hoạt động cần theo dõi cụ thể
    final trackedActivities = {
      "Đi bộ": Colors.blueAccent,
      "Ngồi": Colors.greenAccent,
      "Đứng": Colors.amber,
      "Té": Colors.red,
      "Còn lại": Colors.purpleAccent,
    };

    // Tính thời lượng cho từng loại hoạt động
    Map<String, Duration> activityDurations = {
      for (var key in trackedActivities.keys) key: Duration.zero,
    };

    for (var record in records) {
      DateTime? start = DateTime.tryParse(record.startTime);
      DateTime? end = DateTime.tryParse(record.endTime);

      if (start != null && end != null && end.isAfter(start)) {
        Duration duration = end.difference(start);
        String type = record.activityType;

        if (trackedActivities.containsKey(type) && type != "Còn lại") {
          activityDurations[type] =
              activityDurations[type]! + duration;
        } else {
          activityDurations["Còn lại"] =
              activityDurations["Còn lại"]! + duration;
        }
      }
    }

    Duration totalDuration = activityDurations.values.fold(
        Duration.zero, (sum, dur) => sum + dur);

    if (totalDuration.inSeconds == 0) return [];

    // Tính phần trăm
    Map<String, double> rawPercents = {};
    activityDurations.forEach((activity, duration) {
      rawPercents[activity] =
          duration.inSeconds / totalDuration.inSeconds * 100;
    });

    // Áp dụng min 1%
    Map<String, double> adjustedPercents = {};
    rawPercents.forEach((activity, percent) {
      adjustedPercents[activity] = (percent > 0 && percent < 1) ? 1 : percent;
    });

    // Nếu tổng > 100, điều chỉnh lại
    double adjustedTotal = adjustedPercents.values.fold(0, (a, b) => a + b);
    if (adjustedTotal > 100) {
      String maxActivity = adjustedPercents.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      double excess = adjustedTotal - 100;
      adjustedPercents[maxActivity] =
          adjustedPercents[maxActivity]! - excess;
    }

    // Tạo PieChartSectionData
    List<PieChartSectionData> sections = [];
    adjustedPercents.forEach((activity, percent) {
      if (percent <= 0) return;
      sections.add(PieChartSectionData(
        color: trackedActivities[activity],
        value: percent,
        title: "${percent.toStringAsFixed(0)}%",
        radius: 60,
        titleStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold),
      ));
    });

    return sections;
  }


  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = createChartSectionsFromRecords(
        records);

    if (sections.isEmpty) {
      return const Center(
        child: Text(
          'Dữ liệu đang được cập nhật\nXin bạn chờ trong giây lát...',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      // color: Colors.black,
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