import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/app_drawer.dart';

class HourlyForecastScreen extends StatelessWidget {
  const HourlyForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final hours = provider.hourlyForecast;

    if (hours == null || hours.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Hourly Forecast")),
        drawer: const AppDrawer(),
        body: const Center(child: Text("Load a city first")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Hourly - ${provider.selectedCity}")),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: hours.length,
        itemBuilder: (context, index) {
          final h = hours[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(h.iconUrl),
              title: Text(h.time),
              subtitle: Text(h.condition),
              trailing: Text("${h.tempC} °C"),
            ),
          );
        },
      ),
    );
  }
}
