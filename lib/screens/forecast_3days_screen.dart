import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/weather_provider.dart';

class Forecast3DaysScreen extends StatelessWidget {
  const Forecast3DaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final forecast = provider.forecast3Days;

    if (forecast == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("3 Days Forecast")),
        body: const Center(
          child: Text("No forecast data. Go back and load a city."),
        ),
      );
    }

    final List days = forecast["forecast"]["forecastday"];

    return Scaffold(
      appBar: AppBar(title: Text("3 Days - ${provider.selectedCity}")),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final date = day["date"];
          final condition = day["day"]["condition"]["text"];
          final icon = day["day"]["condition"]["icon"];
          final maxTemp = day["day"]["maxtemp_c"];
          final minTemp = day["day"]["mintemp_c"];
          final chanceOfRain = day["day"]["daily_chance_of_rain"];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Image.network("https:$icon"),
              title: Text(date),
              subtitle: Text("$condition\nRain chance: $chanceOfRain%"),
              isThreeLine: true,
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Max: $maxTemp °C"),
                  Text("Min: $minTemp °C"),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: () async {
            final city = provider.selectedCity ?? provider.city;
            if (city.isEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('No city selected')));
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
          icon: const Icon(Icons.map),
          label: const Text("Open Weather Map"),
        ),
      ),
    );
  }
}
