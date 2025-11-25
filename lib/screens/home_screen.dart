import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchInitialDataIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(prov.city.isNotEmpty ? prov.city : 'Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_city),
            onPressed: () => Navigator.pushNamed(context, '/cities'),
          ),
        ],
      ),
      body: Center(
        child: prov.loading
            ? const CircularProgressIndicator()
            : prov.error != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${prov.error}'),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prov.iconUrl != null)
                    Image.network(
                      prov.iconUrl!,
                      width: 120,
                      height: 120,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    prov.tempC != null
                        ? '${prov.tempC!.toStringAsFixed(1)} °C'
                        : '--',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(prov.condition ?? ''),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forecast3days');
                    },
                    child: const Text('3-day Forecast'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/hourly');
                    },
                    child: const Text('Hourly Forecast'),
                  ),
                ],
              ),
      ),
    );
  }
}
