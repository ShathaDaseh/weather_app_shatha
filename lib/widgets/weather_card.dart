import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String city;
  final String temp;
  final String conditionText;
  final String iconUrl;
  final VoidCallback? onTap;
  final VoidCallback? onDetails;

  const WeatherCard({
    super.key,
    required this.city,
    required this.temp,
    required this.conditionText,
    required this.iconUrl,
    this.onTap,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedIcon =
        iconUrl.startsWith('http') ? iconUrl : "https:$iconUrl";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        leading: Image.network(
          normalizedIcon,
          width: 45,
          height: 45,
          fit: BoxFit.contain,
        ),

        title: Text(
          city,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        subtitle: Text(
          conditionText,
          style: const TextStyle(fontSize: 14),
        ),

        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$temp °C",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (onDetails != null)
              IconButton(
                padding: EdgeInsets.zero, 
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.info_outline, size: 22),
                onPressed: onDetails,
              ),
          ],
        ),
      ),
    );
  }
}
