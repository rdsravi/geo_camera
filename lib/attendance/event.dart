// lib/attendance/event.dart
class Event {
  final String title;
  final String imagePath;
  final String time;
  final String location;
  final DateTime date; // Add a date attribute

  Event(this.title, {required this.imagePath, required this.time, required this.location, required this.date});
}
