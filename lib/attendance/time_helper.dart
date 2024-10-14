// lib/attendance/time_helper.dart
import 'package:intl/intl.dart';

String formatTime(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
}

String formatDate(DateTime dateTime) {
  return DateFormat('EEEE, MMM d').format(dateTime);
}
