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

    if (days == null || days.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("3 Days Forecast")),
        drawer: const AppDrawer(),
        body: const Center(
          child: Text("No forecast data. Go back and load a city."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("3 Days - ${provider.selectedCity}")),
      body: ListView.builder(
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final city = provider.selectedCity ?? provider.city;
              if (city.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                    const SnackBar(content: Text('No city selected')));
                return;
              }

              final encoded = Uri.encodeComponent(city);
              final uri = Uri.parse(
                "https://www.google.com/maps/search/?api=1&query=$encoded",
              );

              try {
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open map')),
                  );
                }
              } catch (_) {
                // ignore: use_build_context_synchronously
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
