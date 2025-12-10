class ForecastDay {
  final String date;
  final double maxTempC;
  final double minTempC;
  final double avgTempC;
  final String condition;
  final String iconUrl;
  final int chanceOfRain;
  final int chanceOfSnow;
  final double uv;

  ForecastDay({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.avgTempC,
    required this.condition,
    required this.iconUrl,
    required this.chanceOfRain,
    required this.chanceOfSnow,
    required this.uv,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'] as String,
      maxTempC: (json['day']['maxtemp_c'] as num).toDouble(),
      minTempC: (json['day']['mintemp_c'] as num).toDouble(),
      avgTempC: (json['day']['avgtemp_c'] as num).toDouble(),
      condition: json['day']['condition']['text'] as String,
      iconUrl: 'https:${json['day']['condition']['icon'] as String}',
      chanceOfRain: json['day']['daily_chance_of_rain'] as int,
      chanceOfSnow: json['day']['daily_chance_of_snow'] as int,
      uv: (json['day']['uv'] as num).toDouble(),
    );
  }
}
