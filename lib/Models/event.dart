import 'package:flutter/material.dart';

class Event {
  final String title;
  final String desc;
  final DateTime from;
  final DateTime to;
  final Color bgCol;
  final bool isAllDay;

  const Event(
      {required this.title,
      required this.desc,
      required this.from,
      required this.to,
      this.bgCol = Colors.tealAccent,
      this.isAllDay = false});
}
