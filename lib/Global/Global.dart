import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String fontName = "Roboto";

bool isSelectUserDashBord = false;
DateTime selectedDate = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();
DateTime dateTime = DateTime.now();
List<String> gender = ['Male', 'Female'];
List<String> relationship = [
  'Mom',
  'Dad',
  'Son',
];
List<String> eventType = [
  'Birthday Party',
  'Merragie',
];
List<String> complaintType = [
  'Urgent',
  'Not Urgent',
];
List<String> complaintStatus = [
  'Open',
  'Close',
];
List<String> eXPENSEType = [
  'Pump Repair',
  'Cleaning',
];

// Select for Date
Future<DateTime> _selectDate(BuildContext context) async {
  final selected = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2025),
  );
  if (selected != null && selected != selectedDate) {
    selectedDate = selected;
  }
  return selectedDate;
}

// Select for Time
Future<TimeOfDay> _selectTime(BuildContext context) async {
  final selected = await showTimePicker(
    context: context,
    initialTime: selectedTime,
  );
  if (selected != null && selected != selectedTime) {
    selectedTime = selected;
  }
  return selectedTime;
}

// select date time picker
Future selectDateTime(BuildContext context) async {
  final date = await _selectDate(context);
  if (date == null) return;

  final time = await _selectTime(context);

  if (time == null) return;
  dateTime = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}

String getDateTime() {
  // ignore: unnecessary_null_comparison
  if (dateTime == null) {
    return 'select date timer';
  } else {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }
}
