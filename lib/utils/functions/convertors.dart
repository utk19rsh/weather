import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather/utils/constants.dart';

class Convertor {
  DateTime epochToDateTime(int time) {
    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  String kelvinToCelsius(dynamic kelvin) {
    double temp = kelvin.toDouble();
    return "${(temp - 273.15).toStringAsFixed(1)}°";
  }

  String formatCurrentDateInDMW() {
    DateTime now = DateTime.now();
    String month = listOfMonths[now.month];
    String weekday = listOfWeekdays[now.weekday];
    return "${now.day} $month, $weekday";
  }

  String extractTime(DateTime time) {
    int h = time.hour;
    int m = time.minute;
    if (h < 12) {
      return "$h:$m am";
    } else {
      return "${h % 12}:$m pm";
    }
  }

  Future<Map<String, dynamic>> extractJson(
    BuildContext context,
    String path,
  ) async {
    String json = await DefaultAssetBundle.of(context).loadString(path);
    return jsonDecode(json);
  }
}
