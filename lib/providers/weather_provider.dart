import 'package:flutter/foundation.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';
import '../models/forecast_day.dart';
import '../models/forecast_hour.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherProvider();

  final WeatherService _service = WeatherService();
  final LocationService _locationService = LocationService();
  final NotificationService _notifier = NotificationService();

  String city = 'Cairo';
  String? selectedCity;

  double? tempC;
  String? condition;
  String? iconUrl;

  Weather? currentWeather;
  List<ForecastDay>? forecastDays;
  List<ForecastHour>? hourlyForecast;

  /// Quick preview cache for the cities list so every row can show live data.
  final Map<String, Map<String, String>> cityPreviewCache = {};

  bool loading = false;

  String? error;

  Future<void> _checkAlertsFromForecast(Map<String, dynamic> forecast) async {
    final alerts = forecast["alerts"]?["alert"] as List<dynamic>?;
    if (alerts != null && alerts.isNotEmpty) {
      await _notifier.showWeatherAlert(alerts.first["headline"] ?? "Weather");
      return;
    }

    final days = (forecast["forecast"]?["forecastday"] as List<dynamic>?) ?? [];
    final hasRain = days.any(
      (d) => (d["day"]?["daily_chance_of_rain"] as num? ?? 0) >= 60,
    );
    final hasSnow = days.any(
      (d) => (d["day"]?["daily_chance_of_snow"] as num? ?? 0) >= 40,
    );
    final hasStorm = days.any((d) {
      final text = (d["day"]?["condition"]?["text"] as String?) ?? "";
      return text.toLowerCase().contains("storm");
    });

    if (hasRain || hasSnow || hasStorm) {
      final message = hasStorm
          ? "Storm conditions expected in $city."
          : hasSnow
              ? "Snow is likely soon in $city."
              : "Rain expected soon in $city.";
      await _notifier.showWeatherAlert(message);
    }
  }

  Future<void> fetchWeather(String q) async {
    loading = true;
    error = null;
    notifyListeners();

    final key =
        const String.fromEnvironment('WEATHER_API_KEY', defaultValue: '');
    if (key.isEmpty) {
      error =
          'Missing WEATHER_API_KEY (provide via --dart-define WEATHER_API_KEY=your_key)';
      loading = false;
      notifyListeners();
      return;
    }

    try {
      final current = await _service.getCurrentWeather(q);
      final forecast = await _service.getForecast3Days(q);

      currentWeather = Weather.fromJson(current);
      city = currentWeather!.city;
      selectedCity = city;
      tempC = currentWeather!.tempC;
      condition = currentWeather!.condition;
      iconUrl = currentWeather!.iconUrl;

      final days = (forecast['forecast']['forecastday'] as List<dynamic>)
          .map((d) => ForecastDay.fromJson(d))
          .toList();
      forecastDays = days;

      // For hourly, take first day's hours
      if (days.isNotEmpty) {
        final hours =
            (forecast['forecast']['forecastday'][0]['hour'] as List<dynamic>)
                .map((h) => ForecastHour.fromJson(h))
                .toList();
        hourlyForecast = hours;
      }

      await _checkAlertsFromForecast(forecast);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> fetchCityPreview(String cityName) async {
    if (cityPreviewCache.containsKey(cityName)) return;
    try {
      final current = await _service.getCurrentWeather(cityName);
      cityPreviewCache[cityName] = {
        "temp": (current['current']['temp_c'] as num).toStringAsFixed(0),
        "condition":
            current['current']['condition']?['text'] as String? ?? "Unknown",
        "icon": "https:${current['current']['condition']?['icon']}",
      };
      notifyListeners();
    } catch (_) {
      cityPreviewCache[cityName] = {
        "temp": "--",
        "condition": "Unavailable",
        "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
      };
      notifyListeners();
    }
  }

  Future<void> loadWeatherByGPS() async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      final position = await _locationService.getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      await fetchWeather("$lat,$lon"); // fetchWeather will set loading to false
    } catch (e) {
      error = e.toString();
      loading = false; // Ensure loading is false on error
      notifyListeners();
    }
  }

  Future<void> refreshSelectedCity() async {
    if ((selectedCity ?? '').isEmpty) return;
    await fetchWeather(selectedCity!);
  }

  Future<void> fetchInitialDataIfNeeded() async {
    if (tempC == null && !loading) {
      await fetchWeather(city);
    }
  }
}
