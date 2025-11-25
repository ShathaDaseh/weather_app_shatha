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
          ? Center(child: CircularProgressIndicator())
          : _forecastData == null
          ? Center(child: Text('No data available'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _forecastData['forecast']['forecastday'].length,
                    itemBuilder: (context, index) {
                      final day =
                          _forecastData['forecast']['forecastday'][index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.network(
                            "https:${day['day']['condition']['icon']}",
                          ),
                          title: Text(day['date']),
                          subtitle: Text(
                            "Max: ${day['day']['maxtemp_c']} °C, Min: ${day['day']['mintemp_c']} °C",
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
    );
  }
}
