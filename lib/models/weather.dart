class Weather {
  final String city;
  final double tempC;
  final String condition;
  final String iconUrl;

  Weather({
    required this.city,
    required this.tempC,
    required this.condition,
    required this.iconUrl,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final current = json['current'];
    return Weather(
      city: location['name'] as String,
      tempC: (current['temp_c'] as num).toDouble(),
      condition: current['condition']['text'] as String,
      iconUrl: 'https:${current['condition']['icon'] as String}',
    );
  }
}
