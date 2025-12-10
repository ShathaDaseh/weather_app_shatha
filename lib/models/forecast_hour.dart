class ForecastHour {
  final String time;
  final double tempC;
  final String condition;
  final String iconUrl;
  final int chanceOfRain;
  final int chanceOfSnow;
  final double windKph;
  final int humidity;
  final double feelsLikeC;

  ForecastHour({
    required this.time,
    required this.tempC,
    required this.condition,
    required this.iconUrl,
    required this.chanceOfRain,
    required this.chanceOfSnow,
    required this.windKph,
    required this.humidity,
    required this.feelsLikeC,
  });

  factory ForecastHour.fromJson(Map<String, dynamic> json) {
    return ForecastHour(
      time: json['time'] as String,
      tempC: (json['temp_c'] as num).toDouble(),
      condition: json['condition']['text'] as String,
      iconUrl: 'https:${json['condition']['icon'] as String}',
      chanceOfRain: json['chance_of_rain'] as int,
      chanceOfSnow: json['chance_of_snow'] as int,
      windKph: (json['wind_kph'] as num).toDouble(),
      humidity: json['humidity'] as int,
      feelsLikeC: (json['feelslike_c'] as num).toDouble(),
    );
  }
}
