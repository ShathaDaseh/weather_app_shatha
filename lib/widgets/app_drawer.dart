import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Center(
              child: Text(
                "Weather App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
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
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text("Cities List"),
            onTap: () => Navigator.pushReplacementNamed(context, '/cities'),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text("Weather Map"),
            onTap: () => Navigator.pushNamed(context, '/weathermap'),
          ),
        ],
      ),
    );
  }
}
