import 'package:flutter/foundation.dart';
import 'package:weather/controller/api.dart';
import 'package:weather/model/statistics.dart';
import 'package:weather/utils/constants.dart';

class Weather {
  API api = API();

  Future<Statistics?> getStatistics(String city) async {
    try {
      dynamic res = await api.fetch(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$openWeatherMapApiKey',
      );
      if ((res as Map<String, dynamic>).isNotEmpty) {
        return Statistics.fromJson(res);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
