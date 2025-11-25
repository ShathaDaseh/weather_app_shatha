import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HourlyForecastScreen extends StatelessWidget {
  const HourlyForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final forecast = provider.forecast3Days;

    if (forecast == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Hourly Forecast")),
        body: const Center(child: Text("Load a city first")),
      );
    }

    final hours = forecast["forecast"]["forecastday"][0]["hour"];

    return Scaffold(
      appBar: AppBar(title: Text("Hourly - ${provider.selectedCity}")),
      body: ListView.builder(
        itemCount: hours.length,
        itemBuilder: (context, index) {
          final h = hours[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network("https:${h["condition"]["icon"]}"),
              title: Text(h["time"]),
              subtitle: Text(h["condition"]["text"]),
              trailing: Text("${h["temp_c"]}°C"),
            ),
          );
        },
      ),
    );
  }
}
