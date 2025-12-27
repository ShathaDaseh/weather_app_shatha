import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/hourly_weather_item.dart';

class HourlyForecastScreen extends StatelessWidget {
  const HourlyForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final hours = provider.hourlyForecast;
    final city = provider.selectedCity ?? provider.city;

    Widget body;
    if (provider.loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (provider.error != null) {
      body = Center(child: Text(provider.error!));
    } else if (hours == null || hours.isEmpty) {
      body = const Center(child: Text("Load a city first"));
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: hours.length,
        itemBuilder: (context, index) {
          final h = hours[index];
          final label = h.time.length > 11 ? h.time.substring(11) : h.time;
          return HourlyWeatherItem(
            hour: label,
            temp: h.tempC.toStringAsFixed(0),
            iconUrl: h.iconUrl,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(city.isEmpty ? "Hourly Forecast" : "Hourly - $city"),
      ),
      drawer: const AppDrawer(),
      body: body,
    );
  }
}
