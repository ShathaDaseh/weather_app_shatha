import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

class DetailedWeatherScreen extends StatefulWidget {
  final String city;

  const DetailedWeatherScreen({super.key, required this.city});

  @override
  // ignore: library_private_types_in_public_api
  _DetailedWeatherScreenState createState() => _DetailedWeatherScreenState();
}

class _DetailedWeatherScreenState extends State<DetailedWeatherScreen> {
  Future<void> _openMap() async {
    final provider = context.read<WeatherProvider>();
    final city = provider.selectedCity ?? widget.city;
    final uri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(city)}");
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
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final days = provider.forecastDays;
    return Scaffold(
      appBar: AppBar(title: Text('3-Day Forecast for ${widget.city}')),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : days == null || days.isEmpty
              ? Center(
                  child: Text(
                      provider.error ?? 'No data available. Pull to refresh.'),
                )
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
                          itemCount: days.length,
                          itemBuilder: (context, index) {
                            final day = days[index];
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
                                      day.iconUrl,
                                      width: 64,
                                      height: 64,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            day.date,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(day.condition),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Max: ${day.maxTempC} °C • Min: ${day.minTempC} °C",
                                          ),
                                          Text(
                                            "Chance of rain: ${day.chanceOfRain}%",
                                            style: const TextStyle(
                                                color: Colors.blueGrey),
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
