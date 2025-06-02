class Position {
  final double latitude;
  final double longitude;

  Position({required this.latitude, required this.longitude});

  @override
  String toString() {
    return 'Position(latitude: $latitude, longitude: $longitude)';
  }
}