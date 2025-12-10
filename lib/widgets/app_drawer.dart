import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.cloud, size: 60, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Weather App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text("Hourly Forecast"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, "/hourly");
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text("Daily Forecast"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, "/forecast3days");
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text("Cities"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, "/cities");
            },
          ),
        ],
      ),
    );
  }
}
