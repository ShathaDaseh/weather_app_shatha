class ForecastDay {
  final String date;
  final double maxTempC;
  final double minTempC;
  final String condition;
  final String iconUrl;
  final int chanceOfRain;

  ForecastDay({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.condition,
    required this.iconUrl,
    required this.chanceOfRain,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'] as String,
      maxTempC: (json['day']['maxtemp_c'] as num).toDouble(),
      minTempC: (json['day']['mintemp_c'] as num).toDouble(),
      condition: json['day']['condition']['text'] as String,
      iconUrl: 'https:${json['day']['condition']['icon'] as String}',
      chanceOfRain: json['day']['daily_chance_of_rain'] as int,
    );
  }
}
