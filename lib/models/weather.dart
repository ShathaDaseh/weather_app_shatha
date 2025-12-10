class Weather {
  final String city;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String localtime;
  final double tempC;
  final double tempF;
  final bool isDay;
  final String condition;
  final String iconUrl;
  final double windKph;
  final int humidity;
  final double pressureMb;
  final double precipMm;
  final double uv;
  final double feelsLikeC;

  Weather({
    required this.city,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.localtime,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.iconUrl,
    required this.windKph,
    required this.humidity,
    required this.pressureMb,
    required this.precipMm,
    required this.uv,
    required this.feelsLikeC,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final current = json['current'];
    return Weather(
      city: location['name'] as String,
      region: location['region'] as String,
      country: location['country'] as String,
      lat: (location['lat'] as num).toDouble(),
      lon: (location['lon'] as num).toDouble(),
      localtime: location['localtime'] as String,
      tempC: (current['temp_c'] as num).toDouble(),
      tempF: (current['temp_f'] as num).toDouble(),
      isDay: current['is_day'] == 1,
      condition: current['condition']['text'] as String,
      iconUrl: 'https:${current['condition']['icon'] as String}',
      windKph: (current['wind_kph'] as num).toDouble(),
      humidity: current['humidity'] as int,
      pressureMb: (current['pressure_mb'] as num).toDouble(),
      precipMm: (current['precip_mm'] as num).toDouble(),
      uv: (current['uv'] as num).toDouble(),
      feelsLikeC: (current['feelslike_c'] as num).toDouble(),
    );
  }
}
