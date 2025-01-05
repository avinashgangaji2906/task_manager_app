import 'package:flutter/widgets.dart';

Color strenghtenColor(Color color, double factor) {
  int r = (color.red * factor).clamp(0, 255).toInt();
  int g = (color.green * factor).clamp(0, 255).toInt();

  int b = (color.blue * factor).clamp(0, 255).toInt();

  return Color.fromARGB(220, r, g, b);
}

List<DateTime> generateWeekDays(int weekOffset) {
  final today = DateTime.now();

  //get start day of week
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));

  // get specific week based on weekOffset value
  startOfWeek = startOfWeek.add(Duration(days: weekOffset * 7));

  // return the list of days in a week from startOftheWeek day
  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToRgb(String hex) {
  return Color(int.parse(hex, radix: 16) +
      0xFF000000); // alpha in argb - for full opacity
}
