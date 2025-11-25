import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  dynamic currentWeather;
  dynamic forecast;
  dynamic hourly;

  final WeatherService _service = WeatherService();

  Future<void> loadCityWeather(String city) async {
    currentWeather = await _service.getCurrentWeather(city);
    forecast = await _service.getForecast(city);
    hourly = await _service.getHourly(city);

    notifyListeners();
  }
}
