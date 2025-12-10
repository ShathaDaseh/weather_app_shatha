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

      // 🔥 عرض أفقي (يعطي شكل أفضل لساعات اليوم)
      body: SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: hours.length,
          itemBuilder: (context, index) {
            final h = hours[index];
            return HourlyWeatherItem(
              hour: h.time.substring(11), // "09:00"
              temp: h.tempC.toString(),
              iconUrl: h.iconUrl,
            );
          },
        ),
      ),
    );
  }
}
