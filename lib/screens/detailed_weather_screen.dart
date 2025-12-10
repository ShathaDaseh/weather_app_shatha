import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailedWeatherScreen extends StatefulWidget {
  final String city;

  const DetailedWeatherScreen({super.key, required this.city});

  @override
  // ignore: library_private_types_in_public_api
  _DetailedWeatherScreenState createState() => _DetailedWeatherScreenState();
}

class _DetailedWeatherScreenState extends State<DetailedWeatherScreen> {
  dynamic _forecastData;
  bool _loading = true;
  final WeatherService _service = WeatherService();

  Future<void> _openMap() async {
    final encoded = Uri.encodeComponent(widget.city);
    final uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$encoded",
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open map')));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  void _loadForecast() async {
    try {
      final data = await _service.getForecast(widget.city, 3);
      if (!mounted) return;
      setState(() {
        _forecastData = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _forecastData = null;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('3-Day Forecast for ${widget.city}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _forecastData == null
          ? const Center(child: Text('No data available'))
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFc2e9fb), Color(0xFFa1c4fd)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _forecastData['forecast']['forecastday'].length,
                      itemBuilder: (context, index) {
                        final day = _forecastData['forecast']['forecastday'][index];
                        return Card(
                          margin: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Image.network(
                                  "https:${day['day']['condition']['icon']}",
                                  width: 64,
                                  height: 64,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        day['date'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(day['day']['condition']['text']),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Max: ${day['day']['maxtemp_c']} °C • Min: ${day['day']['mintemp_c']} °C",
                                      ),
                                      Text(
                                        "Chance of rain: ${day['day']['daily_chance_of_rain']}%",
                                        style: const TextStyle(color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextButton(
                      onPressed: _openMap,
                      child: Text(
                        'Open weather map for ${widget.city}',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
