import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/weather_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherProvider extends ChangeNotifier {
  String city = 'Cairo';
  double? tempC;
  String? condition;
  String? iconUrl;
  bool loading = false;
  String? error;

  final WeatherService _service = WeatherService();
  final LocationService _locationService = LocationService();
  final NotificationService _notifier = NotificationService();

  Map<String, dynamic>? forecast3Days;

  Map<String, dynamic>? currentWeather;

  String? selectedCity;

  bool isLoading = false;

  String? errorMessage;

  void checkAlerts() {
    if (forecast3Days != null) {
      final alerts = forecast3Days!["alerts"]["alert"];
      if (alerts != null && alerts.isNotEmpty) {
        _notifier.showWeatherAlert(alerts[0]["headline"]);
      }
    }
  }

  Future<void> fetchWeather(String q) async {
    loading = true;
    error = null;
    notifyListeners();

    final key = dotenv.env['WEATHER_API_KEY'] ?? '';
    if (key.isEmpty) {
      error = 'Missing WEATHER_API_KEY in .env';
      loading = false;
      notifyListeners();
      return;
    }

    final url =
        'https://api.weatherapi.com/v1/current.json?key=$key&q=${Uri.encodeComponent(q)}&aqi=no';

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        city = data['location']['name'] ?? city;
        tempC = (data['current']['temp_c'] as num?)?.toDouble();
        condition = data['current']['condition']?['text'] as String?;
        final icon = data['current']['condition']?['icon'] as String?;
        iconUrl = icon != null ? 'https:$icon' : null;
        error = null;
      } else {
        error = 'API error ${res.statusCode}';
      }
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadWeatherByGPS() async {
    try {
      isLoading = true;
      notifyListeners();

      final position = await _locationService.getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      currentWeather = await _service.getCurrentWeather("$lat,$lon");

      forecast3Days = await _service.getForecast3Days("$lat,$lon");

      selectedCity = currentWeather!["location"]["name"];

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInitialDataIfNeeded() async {
    if (tempC == null && !loading) {
      await fetchWeather(city);
    }
  }
}
