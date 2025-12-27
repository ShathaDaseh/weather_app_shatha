import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/app_drawer.dart';

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
    final screenSize = MediaQuery.of(context).size;
    final cardWidth =
        (screenSize.width * 0.6).clamp(220.0, 320.0).toDouble();
    final cardHeight = (cardWidth * 1.35).clamp(260.0, 360.0).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(prov.city.isNotEmpty ? prov.city : 'Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_city),
            onPressed: () => Navigator.pushNamed(context, '/cities'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: prov.loading ? null : prov.refreshSelectedCity,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: prov.loading
            ? const CircularProgressIndicator()
            : prov.error != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error: ${prov.error}'),
                  )
                : RefreshIndicator(
                    onRefresh: prov.refreshSelectedCity,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: SizedBox(
                              width: cardWidth,
                              height: cardHeight,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4facfe),
                                      Color(0xFF00f2fe)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 22,
                                  horizontal: 18,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      prov.city,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if (prov.iconUrl != null)
                                      Image.network(
                                        prov.iconUrl!,
                                        width: 140,
                                        height: 140,
                                        errorBuilder: (_, __, ___) =>
                                            const SizedBox(height: 140),
                                      ),
                                    const SizedBox(height: 10),
                                    Text(
                                      prov.tempC != null
                                          ? '${prov.tempC!.toStringAsFixed(1)} °C'
                                          : '--',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      prov.condition ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: ElevatedButton.icon(
                              onPressed:
                                  prov.loading ? null : prov.loadWeatherByGPS,
                              icon: const Icon(Icons.my_location),
                              label: const Text("Use my location"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
