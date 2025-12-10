import 'package:flutter/material.dart';

class HourlyWeatherItem extends StatelessWidget {
  final String hour;
  final String temp;
  final String iconUrl;

  const HourlyWeatherItem({
    super.key,
    required this.hour,
    required this.temp,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(hour, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Image.network(
            iconUrl.startsWith("http") ? iconUrl : "https:$iconUrl",
            width: 40,
          ),
          const SizedBox(height: 6),
          Text("$temp°C", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
