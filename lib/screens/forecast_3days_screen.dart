import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/weather_provider.dart';
import '../widgets/app_drawer.dart';

class Forecast3DaysScreen extends StatelessWidget {
  const Forecast3DaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final days = provider.forecastDays;
    final city = provider.selectedCity ?? provider.city;

    Widget body;
    if (provider.loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (provider.error != null) {
      body = Center(child: Text(provider.error!));
    } else if (days == null || days.isEmpty) {
      body = const Center(
        child: Text("No forecast data. Go back and load a city."),
      );
    } else {
      body = ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Image.network(day.iconUrl),
              title: Text(day.date),
              subtitle:
                  Text("${day.condition}\nRain chance: ${day.chanceOfRain}%"),
              isThreeLine: true,
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Max: ${day.maxTempC} °C"),
                  Text("Min: ${day.minTempC} °C"),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(city.isEmpty ? "3 Days Forecast" : "3 Days - $city"),
      ),
      drawer: const AppDrawer(),
      body: body,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: provider.loading
                ? null
                : () async {
                    final city = provider.selectedCity ?? provider.city;
                    if (city.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No city selected')),
                      );
                      return;
                    }

                    final encoded = Uri.encodeComponent(city);
                    final uri = Uri.parse(
                      "https://www.google.com/maps/search/?api=1&query=$encoded",
                    );

                    try {
                      final canOpen = await canLaunchUrl(uri);
                      if (!context.mounted) return;
                      if (canOpen) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open map')),
                        );
                      }
                    } catch (_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error while opening map')),
                      );
                    }
                  },
            icon: const Icon(Icons.map_outlined),
            label: const Text("Open map"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
