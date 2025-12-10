import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/app_drawer.dart';
import 'detailed_weather_screen.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  final List<String> _allCities = [
    "Hebron",
    "Jerusalem",
    "Ramallah",
    "Bethlehem",
    "Gaza",
    "Nablus",
    "Cairo",
    "Amman",
  ];

  String _filter = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<WeatherProvider>();
      for (final city in _allCities) {
        provider.fetchCityPreview(city);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    final filtered = _allCities
        .where((c) => c.toLowerCase().contains(_filter.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Cities List")),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Filter cities",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() => _filter = value);
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final city = filtered[index];
                final preview = provider.cityPreviewCache[city];
                final temp = preview != null ? preview["temp"] ?? "--" : "--";
                final condition = preview != null
                    ? preview["condition"] ?? "Loading..."
                    : "Loading...";
                final iconUrl = preview != null
                    ? preview["icon"] ??
                        "//cdn.weatherapi.com/weather/64x64/day/113.png"
                    : "//cdn.weatherapi.com/weather/64x64/day/113.png";

                return WeatherCard(
                  city: city,
                  temp: temp,
                  conditionText: condition,
                  iconUrl: iconUrl,
                  onTap: () async {
                    final prov = context.read<WeatherProvider>();
                    final navigator = Navigator.of(context);
                    await prov.fetchWeather(city);
                    if (!mounted) return;
                    navigator.pushNamed('/forecast3days', arguments: city);
                  },
                  onDetails: () async {
                    final prov = context.read<WeatherProvider>();
                    await prov.fetchWeather(city);
                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailedWeatherScreen(city: city),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
