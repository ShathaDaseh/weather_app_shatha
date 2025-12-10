import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _baseUrl = "https://api.weatherapi.com/v1";
  static const String _dartDefineKey =
      String.fromEnvironment('WEATHER_API_KEY', defaultValue: '');

  String _resolveKey() {
    return _dartDefineKey;
  }

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    final key = _resolveKey();
    if (key.isEmpty) {
      throw Exception(
          'Missing WEATHER_API_KEY (provide via .env or --dart-define)');
    }
    final url = Uri.parse(
      "$_baseUrl/current.json?key=${Uri.encodeComponent(key)}&q=${Uri.encodeComponent(city)}&aqi=no",
    );
    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception("Failed to load weather");
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // New: generic forecast fetch for N days
  Future<Map<String, dynamic>> getForecast(String city, int days) async {
    final key = _resolveKey();
    if (key.isEmpty) {
      throw Exception(
          'Missing WEATHER_API_KEY (provide via .env or --dart-define)');
    }
    if (days < 1 || days > 10) {
      throw Exception('days must be between 1 and 10');
    }

    final url = Uri.parse(
      "$_baseUrl/forecast.json?key=${Uri.encodeComponent(key)}&q=${Uri.encodeComponent(city)}&days=$days&aqi=no&alerts=yes",
    );

    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception("Failed to load forecast (status: ${res.statusCode})");
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getForecast3Days(String city) =>
      getForecast(city, 3);
}
