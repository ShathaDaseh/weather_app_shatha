import 'package:flutter/foundation.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';
import '../models/forecast_day.dart';
import '../models/forecast_hour.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherProvider();

  final WeatherService _service = WeatherService();
  final LocationService _locationService = LocationService();
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

  DateTime? _tryParseForecastTime(String value) {
    final normalized = value.replaceFirst(' ', 'T');
    return DateTime.tryParse(normalized);
  }

  int? _readEpochSeconds(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return null;
  }

  int _resolveLocalEpoch(Map<String, dynamic> forecast) {
    final epoch =
        _readEpochSeconds(forecast['location']?['localtime_epoch']);
    if (epoch != null) {
      return epoch;
    }
    final localTime = forecast['location']?['localtime'] as String?;
    final parsed =
        localTime == null ? null : _tryParseForecastTime(localTime);
    if (parsed == null) {
      return DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }
    return parsed.millisecondsSinceEpoch ~/ 1000;
  }

  int? _resolveHourEpoch(Map<String, dynamic> hour) {
    final epoch = _readEpochSeconds(hour['time_epoch']);
    if (epoch != null) {
      return epoch;
    }
    final timeValue = hour['time'] as String?;
    if (timeValue == null) {
      return null;
    }
    final parsed = _tryParseForecastTime(timeValue);
    return parsed!.millisecondsSinceEpoch ~/ 1000;
  }

  List<ForecastHour> _buildNext12Hours(Map<String, dynamic> forecast) {
    final nowEpoch = _resolveLocalEpoch(forecast);
    final startEpoch = nowEpoch - (nowEpoch % 3600);
    final endEpoch = startEpoch + (12 * 3600);
    final result = <ForecastHour>[];

    final days = forecast['forecast']?['forecastday'] as List<dynamic>?;
    if (days == null) {
      return result;
    }

    for (final day in days) {
      final hours = (day as Map<String, dynamic>)['hour'] as List<dynamic>?;
      if (hours == null) continue;
      for (final hour in hours) {
        if (hour is! Map<String, dynamic>) continue;
        final hourEpoch = _resolveHourEpoch(hour);
        if (hourEpoch == null) continue;
        if (hourEpoch < startEpoch || hourEpoch >= endEpoch) {
          continue;
        }
        result.add(ForecastHour.fromJson(hour));
        if (result.length >= 12) {
          return result;
        }
      }
    }

    return result;
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

      hourlyForecast = _buildNext12Hours(forecast);

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
