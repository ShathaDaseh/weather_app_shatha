import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<WeatherProvider>();

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Weather App",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Selected: ${prov.selectedCity ?? prov.city}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text("Cities"),
            onTap: () => Navigator.pushReplacementNamed(context, '/cities'),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text("3-Day Forecast"),
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/forecast3days'),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text("Hourly Forecast"),
            onTap: () => Navigator.pushReplacementNamed(context, '/hourly'),
          ),
        ],
      ),
    );
  }
}
