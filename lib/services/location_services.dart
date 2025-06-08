import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:health_app_ui/models/position.dart';

class LocationServices {
  static final locationref = FirebaseDatabase.instance.ref("location");

  static Stream<Position> get positionStream => locationref.onValue.map((
      event,
      ) {
    try {
      log('Location data changed: ${event.snapshot.value}');
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return Position(latitude: double.parse(data['latitude']), longitude: double.parse(data['longitude']));
    } catch (e) {
      log('Error: ${e.toString()}');
      return Position(latitude: 0, longitude: 0);
    }
  });

  static Future<Position> getCurrentLocation() async {
    //  order by key
    final snapshot = await locationref.orderByKey().limitToLast(1).once();

    final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
    if (data.isEmpty) {
      throw Exception('No location data available');
    }
    final value = data.values.first;

    return Position(latitude: double.parse(value['latitude']), longitude: double.parse(value['longitude']));
  }
}