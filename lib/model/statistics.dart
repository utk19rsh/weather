import 'package:weather/utils/functions/convertors.dart';

class Statistics {
  Statistics({
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.feelsLikeTemperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.groundLevel,
    required this.visibility,
    required this.windSpeed,
    required this.sunriseTime,
    required this.sunsetTime,
  });

  final String description;
  final DateTime sunriseTime, sunsetTime;
  final String pressure, humidity, seaLevel, visibility, groundLevel;
  final String latitude,
      longitude,
      temperature,
      feelsLikeTemperature,
      minTemperature,
      maxTemperature,
      windSpeed;

  factory Statistics.fromJson(Map<String, dynamic> res) {
    Convertor con = Convertor();
    return Statistics(
      longitude: (res['coord']['lon']).toStringAsFixed(1),
      latitude: (res['coord']['lat']).toStringAsFixed(1),
      description: res['weather'][0]['main'],
      temperature: con.kelvinToCelsius(res['main']['temp']),
      feelsLikeTemperature: con.kelvinToCelsius(res['main']['feels_like']),
      minTemperature: con.kelvinToCelsius(res['main']['temp_min']),
      maxTemperature: con.kelvinToCelsius(res['main']['temp_max']),
      pressure: (res['main']['pressure']).toString(),
      humidity: (res['main']['humidity']).toString(),
      seaLevel: (res['main']['sea_level']).toString(),
      groundLevel: (res['main']['grnd_level']).toString(),
      visibility: (res['visibility'] / 1000).toString(),
      windSpeed: (res['wind']['speed']).toString(),
      sunriseTime: con.epochToDateTime(res['sys']['sunrise'] * 1000),
      sunsetTime: con.epochToDateTime(res['sys']['sunset'] * 1000),
      // time is in epock seconds so it needs to be multiplied by 1000
    );
  }
}
