import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_keys.dart';

class WeatherService {
  Future<dynamic> getCurrentWeather(String city) async {
    final url =
        "https://api.weatherapi.com/v1/current.json?key=$weatherApiKey&q=$city&aqi=no";

    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  Future<dynamic> getForecast(String city) async {
    final url =
        "https://api.weatherapi.com/v1/forecast.json?key=$weatherApiKey&q=$city&days=3";

    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  Future<dynamic> getHourly(String city) async {
    final url =
        "https://api.weatherapi.com/v1/forecast.json?key=$weatherApiKey&q=$city&hours=24";

    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }
}
