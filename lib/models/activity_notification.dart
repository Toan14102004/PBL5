// class ActivityNotification {
//   final String title;
//   final String content;
//   final DateTime timestamp;
//
//   ActivityNotification({
//     required this.title,
//     required this.content,
//     required this.timestamp,
//   });
// }

class ActivityNotification {
  final String title;
  final String content;
  final DateTime timestamp;
  final Object? data;

  ActivityNotification({
    required this.title,
    required this.content,
    required this.timestamp,
    this.data,
  });
}