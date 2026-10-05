import 'package:flutter/material.dart';

/// القيم المخزنة في Hive (إنجليزي ثابت) - الترجمة وقت العرض فقط.
const List<String> taskStatuses = ['Pending', 'In Progress', 'Done'];

const List<Color> taskColors = [
  Color(0xFF2196F3),
  Color(0xFF4CAF50),
  Color(0xFFFF9800),
  Color(0xFF9C27B0),
  Color(0xFFF44336),
  Color(0xFF009688),
];

String statusKey(String status) {
  switch (status) {
    case 'Done':
      return 'done';
    case 'In Progress':
      return 'in_progress';
    default:
      return 'pending';
  }
}

Color statusColor(String status) {
  switch (status) {
    case 'Done':
      return const Color(0xFF4CAF50);
    case 'In Progress':
      return const Color(0xFFFF9800);
    default:
      return const Color(0xFF2196F3);
  }
}
