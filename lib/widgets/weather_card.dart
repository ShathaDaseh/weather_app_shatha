import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String city;
  final String temp;
  final String conditionText;
  final String iconUrl;
  final VoidCallback? onTap;

  const WeatherCard({
    super.key,
    required this.city,
    required this.temp,
    required this.conditionText,
    required this.iconUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: Image.network("https:$iconUrl"),
        title: Text(city, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(conditionText),
        trailing: Text(
          "$temp°C",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
