import 'package:cloud_firestore/cloud_firestore.dart';

class TimeFormatter {
  static Timestamp timestamp(
    int year,
    int month,
    int day,
    int hour,
    int minute,
  ) {
    return Timestamp.fromDate(DateTime(year, month, day, hour, minute));
  }
}
