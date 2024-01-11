import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime parseFormattedDay(String formattedDay) {
  List<String> parts = formattedDay.split(' ');
  int day = int.parse(parts[1]);
  String monthString = parts[2];
  int year = int.parse(parts[3]);

  // Mapping month names to numerical values
  final Map<String, int> monthMap = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };

  // Convert monthString to a numerical month
  int month = monthMap[monthString]!;

  return DateTime(year, month, day);
}

//Parse formatted day and time from a single input of the format '01-01-2022 06:00'
DateTime parseFormattedDayAndTime(String formattedDayAndTime) {
  List<String> parts = formattedDayAndTime.split(' ');
  String formattedDay = parts[0];
  String formattedTime = parts[1];

  List<String> dayParts = formattedDay.split('-');
  int day = int.parse(dayParts[0]);
  int month = int.parse(dayParts[1]);
  int year = int.parse(dayParts[2]);

  List<String> timeParts = formattedTime.split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  return DateTime(year, month, day, hour, minute);
}

//Return month name based on int input
String getMonthNameShort(int month) {
  final Map<int, String> monthMap = {
    1: 'Jan',
    2: 'Feb',
    3: 'March',
    4: 'Apr',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'Aug',
    9: 'Sept',
    10: 'Okt',
    11: 'Nov',
    12: 'Dec',
  };

  return monthMap[month]!;
}

DateTime combineDateAndTime(DateTime date, String time) {
  // Parse time string to TimeOfDay
  List<String> timeParts = time.split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);

  // Combine date and time
  return DateTime(
    date.year,
    date.month,
    date.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );
}

List<String> generateNext7Days(DateTime now) {
  List<String> days = [];

  for (int i = 0; i < 7; i++) {
    DateTime nextDay = now.add(Duration(days: i));
    String formattedDay = DateFormat('EEEE DD MMMM y').format(nextDay);
    days.add(formattedDay);
  }

  return days;
}

List<String> generateTimeList() {
  List<String> timeList = [];
  DateTime startTime = DateTime(2022, 1, 1, 6, 0); // Starting at 6:00 AM
  DateTime endTime = DateTime(2022, 1, 1, 22, 15); // Ending at 10:00 PM

  while (startTime.isBefore(endTime)) {
    String formattedTime = DateFormat('HH:mm').format(startTime);
    timeList.add(formattedTime);
    startTime = startTime.add(const Duration(minutes: 15));
  }

  return timeList;
}
