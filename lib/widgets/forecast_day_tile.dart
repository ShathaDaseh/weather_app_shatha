import 'package:flutter/material.dart';

class ForecastDayTile extends StatelessWidget {
  final String date;
  final String iconUrl;
  final String condition;
  final String maxTemp;
  final String minTemp;

  const ForecastDayTile({
    super.key,
    required this.date,
    required this.iconUrl,
    required this.condition,
    required this.maxTemp,
    required this.minTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: Image.network(
          iconUrl.startsWith("http") ? iconUrl : "https:$iconUrl",
          width: 45,
        ),
        title: Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(condition),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("↑ $maxTemp°C",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("↓ $minTemp°C", style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
