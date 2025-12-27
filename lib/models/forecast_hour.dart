class ForecastHour {
  final String time;
  final double tempC;
  final String iconUrl;

  ForecastHour({
    required this.time,
    required this.tempC,
    required this.iconUrl,
  });

  factory ForecastHour.fromJson(Map<String, dynamic> json) {
    return ForecastHour(
      time: json['time'] as String,
      tempC: (json['temp_c'] as num).toDouble(),
      iconUrl: 'https:${json['condition']['icon'] as String}',
    );
  }
}
