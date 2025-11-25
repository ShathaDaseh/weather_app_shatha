import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';

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
  ];

  String _filter = "";
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    final filtered = _allCities
        .where((c) => c.toLowerCase().contains(_filter.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Cities List")),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Weather App",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),
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
                final isSelected = provider.selectedCity == city;

                return WeatherCard(
                  city: city,
                  temp: isSelected && provider.tempC != null
                      ? provider.tempC!.toString()
                      : "--",
                  conditionText: isSelected && provider.condition != null
                      ? provider.condition!
                      : "Tap to load",
                  iconUrl: isSelected && provider.iconUrl != null
                      ? provider.iconUrl!
                      : "//cdn.weatherapi.com/weather/64x64/day/113.png",
                  onTap: () async {
                    final prov = context.read<WeatherProvider>();
                    final navigator = Navigator.of(context);
                    await prov.fetchWeather(city);
                    if (!mounted) return;
                    prov.selectedCity = city;
                    navigator.pushNamed('/forecast3days', arguments: city);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadWeatherForCity(String city) async {
    final prov = context.read<WeatherProvider>();
    await prov.fetchWeather(city);
    setState(() {
      selectedCity = city;
    });
  }
}
